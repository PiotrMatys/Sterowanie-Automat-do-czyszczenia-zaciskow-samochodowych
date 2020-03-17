
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
	.DB  0x4E,0x61,0x63,0x69,0x73,0x6E,0x69,0x6A
	.DB  0x20,0x53,0x54,0x41,0x52,0x54,0x20,0x61
	.DB  0x62,0x79,0x20,0x77,0x79,0x70,0x6F,0x7A
	.DB  0x79,0x63,0x6A,0x6F,0x6E,0x6F,0x77,0x61
	.DB  0x63,0x20,0x6E,0x61,0x70,0x65,0x64,0x79
	.DB  0x0,0x50,0x6F,0x7A,0x79,0x63,0x6A,0x6F
	.DB  0x6E,0x75,0x6A,0x65,0x20,0x75,0x6B,0x6C
	.DB  0x61,0x64,0x79,0x20,0x6C,0x69,0x6E,0x69
	.DB  0x6F,0x77,0x65,0x20,0x58,0x59,0x5A,0x0
	.DB  0x53,0x74,0x65,0x72,0x6F,0x77,0x6E,0x69
	.DB  0x6B,0x20,0x31,0x20,0x2D,0x20,0x77,0x79
	.DB  0x70,0x6F,0x7A,0x79,0x63,0x6A,0x6F,0x6E
	.DB  0x6F,0x77,0x61,0x6C,0x65,0x6D,0x0,0x53
	.DB  0x74,0x65,0x72,0x6F,0x77,0x6E,0x69,0x6B
	.DB  0x20,0x32,0x20,0x2D,0x20,0x77,0x79,0x70
	.DB  0x6F,0x7A,0x79,0x63,0x6A,0x6F,0x6E,0x6F
	.DB  0x77,0x61,0x6C,0x65,0x6D,0x0,0x53,0x74
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
	.DB  0x41,0x6C,0x61,0x72,0x6D,0x20,0x53,0x74
	.DB  0x65,0x72,0x6F,0x77,0x6E,0x69,0x6B,0x20
	.DB  0x31,0x0,0x41,0x6C,0x61,0x72,0x6D,0x20
	.DB  0x53,0x74,0x65,0x72,0x6F,0x77,0x6E,0x69
	.DB  0x6B,0x20,0x32,0x0,0x57,0x79,0x70,0x6F
	.DB  0x7A,0x79,0x63,0x6A,0x6F,0x6E,0x6F,0x77
	.DB  0x61,0x6E,0x6F,0x20,0x75,0x6B,0x6C,0x61
	.DB  0x64,0x79,0x20,0x6C,0x69,0x6E,0x69,0x6F
	.DB  0x77,0x65,0x20,0x58,0x59,0x5A,0x0,0x50
	.DB  0x72,0x7A,0x65,0x63,0x69,0x61,0x7A,0x65
	.DB  0x6E,0x69,0x61,0x20,0x4C,0x45,0x46,0x53
	.DB  0x33,0x32,0x5F,0x31,0x0,0x50,0x72,0x7A
	.DB  0x65,0x63,0x69,0x61,0x7A,0x65,0x6E,0x69
	.DB  0x61,0x20,0x4C,0x45,0x46,0x53,0x33,0x32
	.DB  0x5F,0x32,0x0,0x50,0x72,0x7A,0x65,0x63
	.DB  0x69,0x61,0x7A,0x65,0x6E,0x69,0x61,0x20
	.DB  0x4C,0x45,0x46,0x53,0x5F,0x58,0x59,0x5F
	.DB  0x32,0x0,0x50,0x72,0x7A,0x65,0x63,0x69
	.DB  0x61,0x7A,0x65,0x6E,0x69,0x61,0x20,0x4C
	.DB  0x45,0x46,0x53,0x5F,0x58,0x59,0x5F,0x31
	.DB  0x0,0x57,0x79,0x6D,0x69,0x65,0x6E,0x20
	.DB  0x73,0x7A,0x63,0x7A,0x6F,0x74,0x6B,0x65
	.DB  0x20,0x70,0x65,0x64,0x7A,0x65,0x6C,0x6B
	.DB  0x6F,0x77,0x61,0x0,0x57,0x79,0x6D,0x69
	.DB  0x65,0x6E,0x20,0x6B,0x72,0x61,0x7A,0x65
	.DB  0x6B,0x20,0x73,0x63,0x69,0x65,0x72,0x6E
	.DB  0x79,0x0
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
;
;char sprawdz_pin0(BB PORT, int numer_pcf)
; 0000 00B5 {
_sprawdz_pin0:
; 0000 00B6 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00B7 i2c_write(numer_pcf);
; 0000 00B8 PORT.byte = i2c_read(0);
; 0000 00B9 i2c_stop();
; 0000 00BA 
; 0000 00BB 
; 0000 00BC return PORT.bits.b0;
	RJMP _0x20A0003
; 0000 00BD }
;
;char sprawdz_pin1(BB PORT, int numer_pcf)
; 0000 00C0 {
_sprawdz_pin1:
; 0000 00C1 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00C2 i2c_write(numer_pcf);
; 0000 00C3 PORT.byte = i2c_read(0);
; 0000 00C4 i2c_stop();
; 0000 00C5 
; 0000 00C6 
; 0000 00C7 return PORT.bits.b1;
	LSR  R30
	RJMP _0x20A0003
; 0000 00C8 }
;
;
;char sprawdz_pin2(BB PORT, int numer_pcf)
; 0000 00CC {
_sprawdz_pin2:
; 0000 00CD i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00CE i2c_write(numer_pcf);
; 0000 00CF PORT.byte = i2c_read(0);
; 0000 00D0 i2c_stop();
; 0000 00D1 
; 0000 00D2 
; 0000 00D3 return PORT.bits.b2;
	LSR  R30
	LSR  R30
	RJMP _0x20A0003
; 0000 00D4 }
;
;char sprawdz_pin3(BB PORT, int numer_pcf)
; 0000 00D7 {
_sprawdz_pin3:
; 0000 00D8 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00D9 i2c_write(numer_pcf);
; 0000 00DA PORT.byte = i2c_read(0);
; 0000 00DB i2c_stop();
; 0000 00DC 
; 0000 00DD 
; 0000 00DE return PORT.bits.b3;
	LSR  R30
	LSR  R30
	LSR  R30
	RJMP _0x20A0003
; 0000 00DF }
;
;char sprawdz_pin4(BB PORT, int numer_pcf)
; 0000 00E2 {
_sprawdz_pin4:
; 0000 00E3 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00E4 i2c_write(numer_pcf);
; 0000 00E5 PORT.byte = i2c_read(0);
; 0000 00E6 i2c_stop();
; 0000 00E7 
; 0000 00E8 
; 0000 00E9 return PORT.bits.b4;
	SWAP R30
	RJMP _0x20A0003
; 0000 00EA }
;
;char sprawdz_pin5(BB PORT, int numer_pcf)
; 0000 00ED {
_sprawdz_pin5:
; 0000 00EE i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00EF i2c_write(numer_pcf);
; 0000 00F0 PORT.byte = i2c_read(0);
; 0000 00F1 i2c_stop();
; 0000 00F2 
; 0000 00F3 
; 0000 00F4 return PORT.bits.b5;
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	RJMP _0x20A0003
; 0000 00F5 }
;
;char sprawdz_pin6(BB PORT, int numer_pcf)
; 0000 00F8 {
_sprawdz_pin6:
; 0000 00F9 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 00FA i2c_write(numer_pcf);
; 0000 00FB PORT.byte = i2c_read(0);
; 0000 00FC i2c_stop();
; 0000 00FD 
; 0000 00FE 
; 0000 00FF return PORT.bits.b6;
	CALL SUBOPT_0x1
	RJMP _0x20A0003
; 0000 0100 }
;
;char sprawdz_pin7(BB PORT, int numer_pcf)
; 0000 0103 {
_sprawdz_pin7:
; 0000 0104 i2c_start();
;	PORT -> Y+2
;	numer_pcf -> Y+0
	CALL SUBOPT_0x0
; 0000 0105 i2c_write(numer_pcf);
; 0000 0106 PORT.byte = i2c_read(0);
; 0000 0107 i2c_stop();
; 0000 0108 
; 0000 0109 
; 0000 010A return PORT.bits.b7;
	ROL  R30
	LDI  R30,0
	ROL  R30
_0x20A0003:
	ANDI R30,LOW(0x1)
	ADIW R28,3
	RET
; 0000 010B }
;
;int odczytaj_parametr(int adres1, int adres2)
; 0000 010E {
_odczytaj_parametr:
; 0000 010F int z;
; 0000 0110 z = 0;
	ST   -Y,R17
	ST   -Y,R16
;	adres1 -> Y+4
;	adres2 -> Y+2
;	z -> R16,R17
	__GETWRN 16,17,0
; 0000 0111 putchar(90);
	CALL SUBOPT_0x2
; 0000 0112 putchar(165);
; 0000 0113 putchar(4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _putchar
; 0000 0114 putchar(131);
	LDI  R30,LOW(131)
	CALL SUBOPT_0x3
; 0000 0115 putchar(adres1);
; 0000 0116 putchar(adres2);
; 0000 0117 putchar(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _putchar
; 0000 0118 getchar();
	CALL SUBOPT_0x4
; 0000 0119 getchar();
; 0000 011A getchar();
; 0000 011B getchar();
	CALL SUBOPT_0x4
; 0000 011C getchar();
; 0000 011D getchar();
; 0000 011E getchar();
	CALL SUBOPT_0x4
; 0000 011F getchar();
; 0000 0120 z = getchar();
	MOV  R16,R30
	CLR  R17
; 0000 0121 
; 0000 0122 
; 0000 0123 
; 0000 0124 
; 0000 0125 
; 0000 0126 
; 0000 0127 
; 0000 0128 
; 0000 0129 
; 0000 012A 
; 0000 012B 
; 0000 012C 
; 0000 012D return z;
	MOVW R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20A0002
; 0000 012E }
;
;
;
;int czekaj_na_guzik_start(int adres)
; 0000 0133 {
; 0000 0134 //48 to adres zmiennej 30
; 0000 0135 //16 to adres zmiennj 10
; 0000 0136 
; 0000 0137 int z;
; 0000 0138 z = 0;
;	adres -> Y+2
;	z -> R16,R17
; 0000 0139 putchar(90);
; 0000 013A putchar(165);
; 0000 013B putchar(4);
; 0000 013C putchar(131);
; 0000 013D putchar(0);
; 0000 013E putchar(adres);  //adres zmiennej - 30
; 0000 013F putchar(1);
; 0000 0140 getchar();
; 0000 0141 getchar();
; 0000 0142 getchar();
; 0000 0143 getchar();
; 0000 0144 getchar();
; 0000 0145 getchar();
; 0000 0146 getchar();
; 0000 0147 getchar();
; 0000 0148 z = getchar();
; 0000 0149 //itoa(z,dupa1);
; 0000 014A //lcd_puts(dupa1);
; 0000 014B 
; 0000 014C return z;
; 0000 014D }
;
;
;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0154 {
_timer0_ovf_isr:
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0155 // Place your code here
; 0000 0156 //16,384 ms
; 0000 0157 sek1++;     //Ster 1
	LDI  R26,LOW(_sek1)
	LDI  R27,HIGH(_sek1)
	CALL SUBOPT_0x5
; 0000 0158 sek2++;     //ster 3
	LDI  R26,LOW(_sek2)
	LDI  R27,HIGH(_sek2)
	CALL SUBOPT_0x5
; 0000 0159 
; 0000 015A 
; 0000 015B sek3++;     //ster 2
	LDI  R26,LOW(_sek3)
	LDI  R27,HIGH(_sek3)
	CALL SUBOPT_0x5
; 0000 015C sek4++;     //ster 4
	LDI  R26,LOW(_sek4)
	LDI  R27,HIGH(_sek4)
	CALL SUBOPT_0x5
; 0000 015D 
; 0000 015E 
; 0000 015F //sek10++;
; 0000 0160 
; 0000 0161 sek11++;  //do wyboru zacisku
	LDI  R26,LOW(_sek11)
	LDI  R27,HIGH(_sek11)
	CALL SUBOPT_0x5
; 0000 0162 sek12++;  //do czasu przedmuchu
	LDI  R26,LOW(_sek12)
	LDI  R27,HIGH(_sek12)
	CALL SUBOPT_0x5
; 0000 0163 
; 0000 0164 
; 0000 0165 
; 0000 0166 if(PORTE.3 == 1)
	SBIS 0x3,3
	RJMP _0xD
; 0000 0167       {
; 0000 0168       czas_pracy_szczotki_drucianej++;
	LDI  R26,LOW(_czas_pracy_szczotki_drucianej)
	LDI  R27,HIGH(_czas_pracy_szczotki_drucianej)
	CALL SUBOPT_0x6
; 0000 0169       czas_pracy_krazka_sciernego++;
	LDI  R26,LOW(_czas_pracy_krazka_sciernego)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego)
	CALL SUBOPT_0x6
; 0000 016A       if(czas_pracy_szczotki_drucianej == 61 * 60 * 60)
	LDS  R26,_czas_pracy_szczotki_drucianej
	LDS  R27,_czas_pracy_szczotki_drucianej+1
	CALL SUBOPT_0x7
	BRNE _0xE
; 0000 016B             {
; 0000 016C             czas_pracy_szczotki_drucianej = 0;
	CALL SUBOPT_0x8
; 0000 016D             czas_pracy_szczotki_drucianej_h++;
	CALL SUBOPT_0x9
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
; 0000 016E             }
; 0000 016F       if(czas_pracy_krazka_sciernego == 61 * 60 * 60)
_0xE:
	LDS  R26,_czas_pracy_krazka_sciernego
	LDS  R27,_czas_pracy_krazka_sciernego+1
	CALL SUBOPT_0x7
	BRNE _0xF
; 0000 0170             {
; 0000 0171             czas_pracy_krazka_sciernego = 0;
	CALL SUBOPT_0xA
; 0000 0172             czas_pracy_krazka_sciernego_h++;
	CALL SUBOPT_0xB
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
; 0000 0173             }
; 0000 0174       }
_0xF:
; 0000 0175 
; 0000 0176 
; 0000 0177       //61 razy - 1s
; 0000 0178       //61 * 60 - 1 minuta
; 0000 0179       //61 * 60 * 60 - 1h
; 0000 017A 
; 0000 017B 
; 0000 017C }
_0xD:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
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
; 0000 0185 {
_komunikat_na_panel:
; 0000 0186 int h;
; 0000 0187 
; 0000 0188 h = 0;
	ST   -Y,R17
	ST   -Y,R16
;	*fmtstr -> Y+6
;	adres2 -> Y+4
;	adres22 -> Y+2
;	h -> R16,R17
	__GETWRN 16,17,0
; 0000 0189 h = strlenf(fmtstr);
	CALL SUBOPT_0xC
	CALL _strlenf
	MOVW R16,R30
; 0000 018A h = h + 3;
	__ADDWRN 16,17,3
; 0000 018B 
; 0000 018C putchar(90);
	CALL SUBOPT_0x2
; 0000 018D putchar(165);
; 0000 018E putchar(h);       //ilosc liter 43 + 3
	ST   -Y,R16
	CALL _putchar
; 0000 018F putchar(130);  //82
	LDI  R30,LOW(130)
	CALL SUBOPT_0x3
; 0000 0190 putchar(adres2);    //
; 0000 0191 putchar(adres22);  //
; 0000 0192 printf(fmtstr);
	CALL SUBOPT_0xC
	LDI  R24,0
	CALL _printf
	ADIW R28,2
; 0000 0193 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	RET
;
;
;
;void wartosc_parametru_panelu(int wartosc, int adres1, int adres2)
; 0000 0198 {
_wartosc_parametru_panelu:
; 0000 0199 putchar(90);  //5A
;	wartosc -> Y+4
;	adres1 -> Y+2
;	adres2 -> Y+0
	CALL SUBOPT_0x2
; 0000 019A putchar(165); //A5
; 0000 019B putchar(5);//05
	LDI  R30,LOW(5)
	ST   -Y,R30
	CALL SUBOPT_0xD
; 0000 019C putchar(130);  //82    /
; 0000 019D putchar(adres1);    //00
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _putchar
; 0000 019E putchar(adres2);   //40
	LD   R30,Y
	ST   -Y,R30
	CALL _putchar
; 0000 019F putchar(0);    //00
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _putchar
; 0000 01A0 putchar(wartosc);   //80
	LDD  R30,Y+4
	ST   -Y,R30
	CALL _putchar
; 0000 01A1 }
_0x20A0002:
	ADIW R28,6
	RET
;
;
;void zaktualizuj_parametry_panelu()
; 0000 01A5 {
_zaktualizuj_parametry_panelu:
; 0000 01A6 wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_h,0,144);
	CALL SUBOPT_0x9
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
	RCALL _wartosc_parametru_panelu
; 0000 01A7 
; 0000 01A8 wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h,16,48);
	CALL SUBOPT_0xB
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
	RCALL _wartosc_parametru_panelu
; 0000 01A9 
; 0000 01AA }
	RET
;
;void komunikat_z_czytnika_kodow(char flash *fmtstr,int rzad, int na_plus_minus)
; 0000 01AD {
_komunikat_z_czytnika_kodow:
; 0000 01AE //na_plus_minus = 1;  to jest na plus
; 0000 01AF //na_plus_minus = 0;  to jest na minus
; 0000 01B0 
; 0000 01B1 int h, adres1,adres11,adres2,adres22;
; 0000 01B2 
; 0000 01B3 h = 0;
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
; 0000 01B4 h = strlenf(fmtstr);
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlenf
	MOVW R16,R30
; 0000 01B5 h = h + 3;
	__ADDWRN 16,17,3
; 0000 01B6 
; 0000 01B7 if(rzad == 1)
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,1
	BRNE _0x10
; 0000 01B8    {
; 0000 01B9    adres1 = 0;
	__GETWRN 18,19,0
; 0000 01BA    adres11 = 80;
	__GETWRN 20,21,80
; 0000 01BB    adres2 = 80;
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 01BC    adres22 = 0;
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
; 0000 01BD    }
; 0000 01BE if(rzad == 2)
_0x10:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,2
	BRNE _0x11
; 0000 01BF    {
; 0000 01C0    adres1 = 0;
	__GETWRN 18,19,0
; 0000 01C1    adres11 = 32;
	__GETWRN 20,21,32
; 0000 01C2    adres2 = 64;
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 01C3    adres22 = 0;
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
; 0000 01C4    }
; 0000 01C5 
; 0000 01C6 putchar(90);
_0x11:
	CALL SUBOPT_0x2
; 0000 01C7 putchar(165);
; 0000 01C8 putchar(h);       //ilosc liter 43 + 3
	ST   -Y,R16
	CALL SUBOPT_0xD
; 0000 01C9 putchar(130);  //82
; 0000 01CA putchar(adres1);    //
	ST   -Y,R18
	CALL _putchar
; 0000 01CB putchar(adres11);  //
	ST   -Y,R20
	CALL _putchar
; 0000 01CC printf(fmtstr);
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
; 0000 01CD 
; 0000 01CE 
; 0000 01CF if(rzad == 1 & macierz_zaciskow[rzad]==0)
	CALL SUBOPT_0x12
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	CALL SUBOPT_0x13
	CALL __GETW1P
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	CALL __EQW12
	AND  R30,R0
	BREQ _0x12
; 0000 01D0     {
; 0000 01D1     komunikat_na_panel("                                                ",adres2,adres22);
	CALL SUBOPT_0x14
; 0000 01D2     komunikat_na_panel("Zacisk nie zmierzony u Wykonawcy",adres2,adres22);
	__POINTW1FN _0x0,49
	CALL SUBOPT_0x15
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
; 0000 01D3     }
; 0000 01D4 
; 0000 01D5 if(rzad == 1 & na_plus_minus == 1)
_0x12:
	CALL SUBOPT_0x12
	CALL SUBOPT_0x17
	BREQ _0x13
; 0000 01D6     {
; 0000 01D7     komunikat_na_panel("                                                ",adres2,adres22);
	CALL SUBOPT_0x14
; 0000 01D8     komunikat_na_panel("Os zacisku blizej szafy",adres2,adres22);
	__POINTW1FN _0x0,82
	CALL SUBOPT_0x15
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
; 0000 01D9     }
; 0000 01DA 
; 0000 01DB if(rzad == 1 & na_plus_minus == 0)
_0x13:
	CALL SUBOPT_0x12
	CALL SUBOPT_0x18
	BREQ _0x14
; 0000 01DC     {
; 0000 01DD     komunikat_na_panel("                                                ",adres2,adres22);
	CALL SUBOPT_0x14
; 0000 01DE     komunikat_na_panel("Os zacisku dalej od szafy",adres2,adres22);
	__POINTW1FN _0x0,106
	CALL SUBOPT_0x15
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
; 0000 01DF     }
; 0000 01E0 
; 0000 01E1 
; 0000 01E2 if(rzad == 2 & na_plus_minus == 1)
_0x14:
	CALL SUBOPT_0x19
	CALL SUBOPT_0x17
	BREQ _0x15
; 0000 01E3     {
; 0000 01E4     komunikat_na_panel("                                                ",adres2,adres22);
	CALL SUBOPT_0x14
; 0000 01E5     komunikat_na_panel("Os zacisku dalej od szafy",adres2,adres22);
	__POINTW1FN _0x0,106
	CALL SUBOPT_0x15
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
; 0000 01E6     }
; 0000 01E7 
; 0000 01E8 if(rzad == 2 & na_plus_minus == 0)
_0x15:
	CALL SUBOPT_0x19
	CALL SUBOPT_0x18
	BREQ _0x16
; 0000 01E9     {
; 0000 01EA     komunikat_na_panel("                                                ",adres2,adres22);
	CALL SUBOPT_0x14
; 0000 01EB     komunikat_na_panel("Os zacisku blizej szafy",adres2,adres22);
	__POINTW1FN _0x0,82
	CALL SUBOPT_0x15
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
; 0000 01EC     }
; 0000 01ED 
; 0000 01EE 
; 0000 01EF }
_0x16:
	CALL __LOADLOCR6
	ADIW R28,16
	RET
;
;void zerowanie_pam_wew()
; 0000 01F2 {
_zerowanie_pam_wew:
; 0000 01F3 if(czas_pracy_szczotki_drucianej_h >= 255 | czas_pracy_krazka_sciernego_h >=255 | czas_pracy_krazka_sciernego_stala >= 255 | czas_pracy_szczotki_drucianej_stala >= 255 |
; 0000 01F4    szczotka_druciana_ilosc_cykli >= 255 | krazek_scierny_ilosc_cykli >= 255 | krazek_scierny_cykl_po_okregu_ilosc >=255)
	CALL SUBOPT_0x9
	CALL SUBOPT_0x1A
	MOV  R0,R30
	CALL SUBOPT_0xB
	CALL SUBOPT_0x1A
	OR   R0,R30
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1A
	OR   R0,R30
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1A
	OR   R0,R30
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1A
	OR   R0,R30
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1A
	OR   R0,R30
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x1A
	OR   R30,R0
	BREQ _0x17
; 0000 01F5      {
; 0000 01F6      czas_pracy_szczotki_drucianej_h = 0;
	CALL SUBOPT_0x20
; 0000 01F7      czas_pracy_szczotki_drucianej = 0;
	CALL SUBOPT_0x8
; 0000 01F8      czas_pracy_krazka_sciernego_h = 0;
	CALL SUBOPT_0x21
; 0000 01F9      czas_pracy_krazka_sciernego = 0;
	CALL SUBOPT_0xA
; 0000 01FA      czas_pracy_krazka_sciernego_stala = 5;
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_stala)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_stala)
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EEPROMWRW
; 0000 01FB      czas_pracy_szczotki_drucianej_stala = 5;
	LDI  R26,LOW(_czas_pracy_szczotki_drucianej_stala)
	LDI  R27,HIGH(_czas_pracy_szczotki_drucianej_stala)
	CALL __EEPROMWRW
; 0000 01FC      szczotka_druciana_ilosc_cykli = 3;
	LDI  R26,LOW(_szczotka_druciana_ilosc_cykli)
	LDI  R27,HIGH(_szczotka_druciana_ilosc_cykli)
	CALL SUBOPT_0x22
; 0000 01FD      krazek_scierny_ilosc_cykli = 3;
	LDI  R26,LOW(_krazek_scierny_ilosc_cykli)
	LDI  R27,HIGH(_krazek_scierny_ilosc_cykli)
	CALL SUBOPT_0x22
; 0000 01FE      krazek_scierny_cykl_po_okregu_ilosc = 3;
	LDI  R26,LOW(_krazek_scierny_cykl_po_okregu_ilosc)
	LDI  R27,HIGH(_krazek_scierny_cykl_po_okregu_ilosc)
	CALL SUBOPT_0x22
; 0000 01FF      }
; 0000 0200 
; 0000 0201 /*
; 0000 0202 if(czas_pracy_krazka_sciernego_h >= 255)
; 0000 0203      {
; 0000 0204      czas_pracy_krazka_sciernego_h = 0;
; 0000 0205      czas_pracy_krazka_sciernego = 0;
; 0000 0206      }
; 0000 0207 if(czas_pracy_krazka_sciernego_stala >= 255)
; 0000 0208      czas_pracy_krazka_sciernego_stala = 5;
; 0000 0209 
; 0000 020A if(czas_pracy_szczotki_drucianej_stala >= 255)
; 0000 020B      czas_pracy_szczotki_drucianej_stala = 5;
; 0000 020C 
; 0000 020D if(szczotka_druciana_ilosc_cykli >= 255)
; 0000 020E 
; 0000 020F if(krazek_scierny_ilosc_cykli >= 255)
; 0000 0210 
; 0000 0211 if(krazek_scierny_cykl_po_okregu_ilosc >=255)
; 0000 0212 */
; 0000 0213 
; 0000 0214 }
_0x17:
	RET
;
;
;void odpytaj_parametry_panelu()
; 0000 0218 {
_odpytaj_parametry_panelu:
; 0000 0219 if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
	CALL SUBOPT_0x23
	RCALL _sprawdz_pin0
	LDI  R26,LOW(0)
	CALL __EQB12
	PUSH R30
	CALL SUBOPT_0x23
	RCALL _sprawdz_pin1
	LDI  R26,LOW(0)
	CALL __EQB12
	POP  R26
	AND  R30,R26
	BREQ _0x18
; 0000 021A     start = odczytaj_parametr(0,64);
	CALL SUBOPT_0x24
	CALL SUBOPT_0x25
	MOVW R12,R30
; 0000 021B il_zaciskow_rzad_1 = odczytaj_parametr(0,128);
_0x18:
	CALL SUBOPT_0x24
	CALL SUBOPT_0x26
	CALL SUBOPT_0x27
; 0000 021C il_zaciskow_rzad_2 = odczytaj_parametr(0,48);
	CALL SUBOPT_0x11
	CALL SUBOPT_0x28
; 0000 021D 
; 0000 021E szczotka_druciana_ilosc_cykli = odczytaj_parametr(48,64);
	CALL SUBOPT_0x25
	CALL SUBOPT_0x29
; 0000 021F                                                 //2090
; 0000 0220 krazek_scierny_ilosc_cykli = odczytaj_parametr(32,144);
	CALL SUBOPT_0x2A
; 0000 0221                                                     //3000
; 0000 0222 krazek_scierny_cykl_po_okregu_ilosc = odczytaj_parametr(48,0);
	CALL SUBOPT_0x2B
; 0000 0223 
; 0000 0224 
; 0000 0225 czas_pracy_szczotki_drucianej_stala = odczytaj_parametr(16,112);
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2D
	RCALL _odczytaj_parametr
	LDI  R26,LOW(_czas_pracy_szczotki_drucianej_stala)
	LDI  R27,HIGH(_czas_pracy_szczotki_drucianej_stala)
	CALL __EEPROMWRW
; 0000 0226 
; 0000 0227 czas_pracy_krazka_sciernego_stala = odczytaj_parametr(32,16);
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	CALL SUBOPT_0x10
	RCALL _odczytaj_parametr
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_stala)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_stala)
	CALL __EEPROMWRW
; 0000 0228 
; 0000 0229 czas_pracy_szczotki_drucianej_h = odczytaj_parametr(0,144);
	CALL SUBOPT_0x24
	CALL SUBOPT_0xF
	RCALL _odczytaj_parametr
	LDI  R26,LOW(_czas_pracy_szczotki_drucianej_h)
	LDI  R27,HIGH(_czas_pracy_szczotki_drucianej_h)
	CALL __EEPROMWRW
; 0000 022A 
; 0000 022B czas_pracy_krazka_sciernego_h = odczytaj_parametr(16,48);
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x11
	RCALL _odczytaj_parametr
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h)
	CALL __EEPROMWRW
; 0000 022C 
; 0000 022D test_geometryczny_rzad_1 = odczytaj_parametr(48,80);
	CALL SUBOPT_0x11
	CALL SUBOPT_0x2E
	RCALL _odczytaj_parametr
	STS  _test_geometryczny_rzad_1,R30
	STS  _test_geometryczny_rzad_1+1,R31
; 0000 022E 
; 0000 022F test_geometryczny_rzad_2 = odczytaj_parametr(48,96);
	CALL SUBOPT_0x11
	CALL SUBOPT_0x2F
	RCALL _odczytaj_parametr
	STS  _test_geometryczny_rzad_2,R30
	STS  _test_geometryczny_rzad_2+1,R31
; 0000 0230 
; 0000 0231                                                 //2050
; 0000 0232 zerowanie_pam_wew();
	RCALL _zerowanie_pam_wew
; 0000 0233 
; 0000 0234 }
	RET
;
;void wyrrrjscia_i_wejscia_opis()
; 0000 0237 {
; 0000 0238 
; 0000 0239 
; 0000 023A //IN0
; 0000 023B 
; 0000 023C //komunikacja miedzy slave a master
; 0000 023D //sprawdz_pin0(PORTHH,0x73)
; 0000 023E //sprawdz_pin1(PORTHH,0x73)
; 0000 023F //sprawdz_pin2(PORTHH,0x73)
; 0000 0240 //sprawdz_pin3(PORTHH,0x73)
; 0000 0241 //sprawdz_pin4(PORTHH,0x73)
; 0000 0242 //sprawdz_pin5(PORTHH,0x73)
; 0000 0243 //sprawdz_pin6(PORTHH,0x73)
; 0000 0244 //sprawdz_pin7(PORTHH,0x73)
; 0000 0245 
; 0000 0246 //IN1
; 0000 0247 //sprawdz_pin0(PORTJJ,0x79)  BUSY   STEROWNIK1
; 0000 0248 //sprawdz_pin1(PORTJJ,0x79)  AREA   STEROWNIK1
; 0000 0249 //sprawdz_pin2(PORTJJ,0x79)  SETON  STEROWNIK1
; 0000 024A //sprawdz_pin3(PORTJJ,0x79)  INP    STEROWNIK1
; 0000 024B //sprawdz_pin4(PORTJJ,0x79)  SVRE   STEROWNIK1
; 0000 024C //sprawdz_pin5(PORTJJ,0x79)  ALARM  STEROWNIK1
; 0000 024D //sprawdz_pin6(PORTJJ,0x79)  czujnik cisnienia
; 0000 024E //sprawdz_pin7(PORTJJ,0x79)
; 0000 024F 
; 0000 0250 //IN2
; 0000 0251 //sprawdz_pin0(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK3
; 0000 0252 //sprawdz_pin1(PORTKK,0x75)  B8 AREA    LECP6 STEROWNIK3
; 0000 0253 //sprawdz_pin2(PORTKK,0x75)  B9 SETON   LECP6 STEROWNIK3
; 0000 0254 //sprawdz_pin3(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK3
; 0000 0255 //sprawdz_pin4(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK4
; 0000 0256 //sprawdz_pin5(PORTKK,0x75)  B8 AREA    LECP6 STEROWNIK4
; 0000 0257 //sprawdz_pin6(PORTKK,0x75)  B9 SETON   LECP6 STEROWNIK4
; 0000 0258 //sprawdz_pin7(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK4
; 0000 0259 
; 0000 025A //IN3
; 0000 025B //sprawdz_pin0(PORTLL,0x71)  BUSY   STEROWNIK2
; 0000 025C //sprawdz_pin1(PORTLL,0x71)  AREA   STEROWNIK2
; 0000 025D //sprawdz_pin2(PORTLL,0x71)  SETON  STEROWNIK2
; 0000 025E //sprawdz_pin3(PORTLL,0x71)  INP    STEROWNIK2
; 0000 025F //sprawdz_pin4(PORTLL,0x71)  SVRE   STEROWNIK2
; 0000 0260 //sprawdz_pin5(PORTLL,0x71)  ALARM  STEROWNIK2
; 0000 0261 //sprawdz_pin6(PORTLL,0x71)  S6A przek³adanie rzedow
; 0000 0262 //sprawdz_pin7(PORTLL,0x71)  S6B przekladanie rzedow
; 0000 0263 
; 0000 0264 //IN4
; 0000 0265 //sprawdz_pin0(PORTMM,0x77) J2  czujnik indukcyjny domkniecia pokrywy
; 0000 0266 //sprawdz_pin1(PORTMM,0x77) J3  czujnik indukcyjny domkniecia pokrywy
; 0000 0267 //sprawdz_pin2(PORTMM,0x77)
; 0000 0268 //sprawdz_pin3(PORTMM,0x77)
; 0000 0269 //sprawdz_pin4(PORTMM,0x77)
; 0000 026A //sprawdz_pin5(PORTMM,0x77)
; 0000 026B //sprawdz_pin6(PORTMM,0x77) ALARM STEROWNIK4
; 0000 026C //sprawdz_pin7(PORTMM,0x77) ALARM STEROWNIK3
; 0000 026D 
; 0000 026E //sterownik 1 i sterownik 3 - krazek scierny
; 0000 026F //sterownik 2 i sterownik 4 - druciak
; 0000 0270 
; 0000 0271 //OUT
; 0000 0272 //PORTA.0   IN0  STEROWNIK1        OUT 1
; 0000 0273 //PORTA.1   IN1  STEROWNIK1
; 0000 0274 //PORTA.2   IN2  STEROWNIK1
; 0000 0275 //PORTA.3   IN3  STEROWNIK1
; 0000 0276 //PORTA.4   IN4  STEROWNIK1
; 0000 0277 //PORTA.5   IN5  STEROWNIK1
; 0000 0278 //PORTA.6   IN6  STEROWNIK1
; 0000 0279 //PORTA.7   IN7  STEROWNIK1
; 0000 027A 
; 0000 027B //PORTB.0   IN0  STEROWNIK4        OUT 5
; 0000 027C //PORTB.1   IN1  STEROWNIK4
; 0000 027D //PORTB.2   IN2  STEROWNIK4
; 0000 027E //PORTB.3   IN3  STEROWNIK4
; 0000 027F //PORTB.4   4B CEWKA przedmuch osi
; 0000 0280 //PORTB.5   DRIVE  STEROWNIK4
; 0000 0281 //PORTB.6   swiatlo zielone
; 0000 0282 //PORTB.7   IN5 STEROWNIK 3
; 0000 0283 
; 0000 0284 //PORTC.0   IN0  STEROWNIK2        OUT 3
; 0000 0285 //PORTC.1   IN1  STEROWNIK2
; 0000 0286 //PORTC.2   IN2  STEROWNIK2
; 0000 0287 //PORTC.3   IN3  STEROWNIK2
; 0000 0288 //PORTC.4   IN4  STEROWNIK2
; 0000 0289 //PORTC.5   IN5  STEROWNIK2
; 0000 028A //PORTC.6   IN6  STEROWNIK2
; 0000 028B //PORTC.7   IN7  STEROWNIK2
; 0000 028C 
; 0000 028D //PORTD.0  SDA                     OUT 2
; 0000 028E //PORTD.1  SCL
; 0000 028F //PORTD.2  SETUP   STEROWNIK1 STEROWNIK 2 STEROIWNIK 3 STEROWNIK 4
; 0000 0290 //PORTD.3  DRIVE   STEROWNIK1
; 0000 0291 //PORTD.4  IN8 STEROWNIK1
; 0000 0292 //PORTD.5  IN8 STEROWNIK2
; 0000 0293 //PORTD.6  DRIVE   STEROWNIK2
; 0000 0294 //PORTD.7  swiatlo czerwone i jednoczesnie HOLD
; 0000 0295 
; 0000 0296 //PORTE.0
; 0000 0297 //PORTE.1
; 0000 0298 //PORTE.2  1A CEWKA szczotka druciana                    OUT 6
; 0000 0299 //PORTE.3  1B CEWKA krazek scierny
; 0000 029A //PORTE.4  IN4  STEROWNIK4
; 0000 029B //PORTE.5  IN5  STEROWNIK4
; 0000 029C //PORTE.6  2A CEWKA przerzucanie docisku zaciskow
; 0000 029D //PORTE.7  3A CEWKA zacisnij zaciski
; 0000 029E 
; 0000 029F //PORTF.0   IN0  STEROWNIK3             OUT 4
; 0000 02A0 //PORTF.1   IN1  STEROWNIK3
; 0000 02A1 //PORTF.2   IN2  STEROWNIK3
; 0000 02A2 //PORTF.3   IN3  STEROWNIK3
; 0000 02A3 //PORTF.4   4A CEWKA przedmuch zaciskow
; 0000 02A4 //PORTF.5   DRIVE  STEROWNIK3
; 0000 02A5 //PORTF.6   swiatlo zolte
; 0000 02A6 //PORTF.7   IN4 STEROWNIK 3
; 0000 02A7 
; 0000 02A8 
; 0000 02A9 
; 0000 02AA  //PORT_F.bits.b4 = 0;  //przedmuch zaciskow
; 0000 02AB //PORTF = PORT_F.byte;
; 0000 02AC //PORTB.4 = 1;  //przedmuch osi
; 0000 02AD //PORTE.2 = 1;  //szlifierka 1
; 0000 02AE //PORTE.3 = 1;  //szlifierka 2
; 0000 02AF //PORTE.6 = 0;  //zacisniety rzad 1
; 0000 02B0 //PORTE.6 = 1;  //zacisniety rzad 2
; 0000 02B1 //PORTE.7 = 0;    //zacisnij zaciski
; 0000 02B2 
; 0000 02B3 
; 0000 02B4 //macierz_zaciskow[rzad]=44; brak
; 0000 02B5 //macierz_zaciskow[rzad]=48; brak
; 0000 02B6 //macierz_zaciskow[rzad]=76  brak
; 0000 02B7 //macierz_zaciskow[rzad]=80; brak
; 0000 02B8 //macierz_zaciskow[rzad]=92; brak
; 0000 02B9 //macierz_zaciskow[rzad]=96;  brak
; 0000 02BA //macierz_zaciskow[rzad]=107; brak
; 0000 02BB //macierz_zaciskow[rzad]=111; brak
; 0000 02BC 
; 0000 02BD 
; 0000 02BE 
; 0000 02BF 
; 0000 02C0 /*
; 0000 02C1 
; 0000 02C2 //testy parzystych i nieparzystych IN0-IN8
; 0000 02C3 //testy port/pin
; 0000 02C4 //sterownik 3
; 0000 02C5 //PORTF.0   IN0  STEROWNIK3
; 0000 02C6 //PORTF.1   IN1  STEROWNIK3
; 0000 02C7 //PORTF.2   IN2  STEROWNIK3
; 0000 02C8 //PORTF.3   IN3  STEROWNIK3
; 0000 02C9 //PORTF.7   IN4 STEROWNIK 3
; 0000 02CA //PORTB.7   IN5 STEROWNIK 3
; 0000 02CB 
; 0000 02CC 
; 0000 02CD PORT_F.bits.b0 = 0;
; 0000 02CE PORT_F.bits.b1 = 1;
; 0000 02CF PORT_F.bits.b2 = 0;
; 0000 02D0 PORT_F.bits.b3 = 1;
; 0000 02D1 PORT_F.bits.b7 = 0;
; 0000 02D2 PORTF = PORT_F.byte;
; 0000 02D3 PORTB.7 = 1;
; 0000 02D4 
; 0000 02D5 //sterownik 4
; 0000 02D6 
; 0000 02D7 //PORTB.0   IN0  STEROWNIK4        OUT 5
; 0000 02D8 //PORTB.1   IN1  STEROWNIK4
; 0000 02D9 //PORTB.2   IN2  STEROWNIK4
; 0000 02DA //PORTB.3   IN3  STEROWNIK4
; 0000 02DB //PORTE.4  IN4  STEROWNIK4
; 0000 02DC //PORTE.5  IN5  STEROWNIK4
; 0000 02DD 
; 0000 02DE PORTB.0 = 0;
; 0000 02DF PORTB.1 = 1;
; 0000 02E0 PORTB.2 = 0;
; 0000 02E1 PORTB.3 = 1;
; 0000 02E2 PORTE.4 = 0;
; 0000 02E3 PORTE.5 = 1;
; 0000 02E4 
; 0000 02E5 //ster 1
; 0000 02E6 PORTA.0 = 0;   //IN0  STEROWNIK1        OUT 1
; 0000 02E7 PORTA.1 = 1;  //IN1  STEROWNIK1
; 0000 02E8 PORTA.2 = 0;  // IN2  STEROWNIK1
; 0000 02E9 PORTA.3 = 1;  //IN3  STEROWNIK1
; 0000 02EA PORTA.4 = 0;  // IN4  STEROWNIK1
; 0000 02EB PORTA.5 = 1;  //IN5  STEROWNIK1
; 0000 02EC PORTA.6 = 0;   //IN6  STEROWNIK1
; 0000 02ED PORTA.7 = 1;  //IN7  STEROWNIK1
; 0000 02EE PORTD.4 = 0; //IN8 STEROWNIK1
; 0000 02EF 
; 0000 02F0 
; 0000 02F1 
; 0000 02F2 //sterownik 2
; 0000 02F3 PORTC.0 = 0;   //IN0  STEROWNIK2        OUT 3
; 0000 02F4 PORTC.1  = 1;  //IN1  STEROWNIK2
; 0000 02F5 PORTC.2 = 0;    //IN2  STEROWNIK2
; 0000 02F6 PORTC.3= 1;   //IN3  STEROWNIK2
; 0000 02F7 PORTC.4 = 0;   // IN4  STEROWNIK2
; 0000 02F8 PORTC.5= 1;   //IN5  STEROWNIK2
; 0000 02F9 PORTC.6 = 0;   // IN6  STEROWNIK2
; 0000 02FA PORTC.7= 1;   //IN7  STEROWNIK2
; 0000 02FB PORTD.5 = 0;  //IN8 STEROWNIK2
; 0000 02FC 
; 0000 02FD */
; 0000 02FE 
; 0000 02FF }
;
;void sprawdz_cisnienie()
; 0000 0302 {
_sprawdz_cisnienie:
; 0000 0303 int i;
; 0000 0304 //i = 0;
; 0000 0305 i = 1;
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,1
; 0000 0306 
; 0000 0307 while(i == 0)
_0x19:
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x1B
; 0000 0308     {
; 0000 0309     if(sprawdz_pin6(PORTJJ,0x79) == 0)
	CALL SUBOPT_0x30
	RCALL _sprawdz_pin6
	CPI  R30,0
	BRNE _0x1C
; 0000 030A         {
; 0000 030B         i = 1;
	__GETWRN 16,17,1
; 0000 030C         komunikat_na_panel("                                                ",adr1,adr2);
	__POINTW1FN _0x0,0
	RJMP _0x49A
; 0000 030D         }
; 0000 030E     else
_0x1C:
; 0000 030F         {
; 0000 0310         i = 0;
	__GETWRN 16,17,0
; 0000 0311         komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x31
; 0000 0312         komunikat_na_panel("Cisnienie za male - mniejsze niz 6 bar",adr1,adr2);
	__POINTW1FN _0x0,132
_0x49A:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x32
; 0000 0313         }
; 0000 0314     }
	RJMP _0x19
_0x1B:
; 0000 0315 }
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;
;int odczyt_wybranego_zacisku()
; 0000 0319 {                         //11
_odczyt_wybranego_zacisku:
; 0000 031A int rzad;
; 0000 031B 
; 0000 031C PORT_CZYTNIK.bits.b0 = sprawdz_pin0(PORTHH,0x73);
	ST   -Y,R17
	ST   -Y,R16
;	rzad -> R16,R17
	CALL SUBOPT_0x33
	RCALL _sprawdz_pin0
	ANDI R30,LOW(0x1)
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xFE
	CALL SUBOPT_0x34
; 0000 031D PORT_CZYTNIK.bits.b1 = sprawdz_pin1(PORTHH,0x73);
	RCALL _sprawdz_pin1
	ANDI R30,LOW(0x1)
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xFD
	CALL SUBOPT_0x34
; 0000 031E PORT_CZYTNIK.bits.b2 = sprawdz_pin2(PORTHH,0x73);
	RCALL _sprawdz_pin2
	ANDI R30,LOW(0x1)
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xFB
	CALL SUBOPT_0x34
; 0000 031F PORT_CZYTNIK.bits.b3 = sprawdz_pin3(PORTHH,0x73);
	RCALL _sprawdz_pin3
	ANDI R30,LOW(0x1)
	LSL  R30
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0XF7
	CALL SUBOPT_0x34
; 0000 0320 PORT_CZYTNIK.bits.b4 = sprawdz_pin4(PORTHH,0x73);
	RCALL _sprawdz_pin4
	ANDI R30,LOW(0x1)
	SWAP R30
	ANDI R30,0xF0
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xEF
	CALL SUBOPT_0x34
; 0000 0321 PORT_CZYTNIK.bits.b5 = sprawdz_pin5(PORTHH,0x73);
	RCALL _sprawdz_pin5
	ANDI R30,LOW(0x1)
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xDF
	CALL SUBOPT_0x34
; 0000 0322 PORT_CZYTNIK.bits.b6 = sprawdz_pin6(PORTHH,0x73);
	RCALL _sprawdz_pin6
	ANDI R30,LOW(0x1)
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_CZYTNIK
	ANDI R30,0xBF
	CALL SUBOPT_0x34
; 0000 0323 PORT_CZYTNIK.bits.b7 = sprawdz_pin7(PORTHH,0x73);
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
; 0000 0324 
; 0000 0325 rzad = odczytaj_parametr(32,128);       //20,80
	CALL SUBOPT_0x35
	CALL SUBOPT_0x26
	MOVW R16,R30
; 0000 0326 
; 0000 0327 if(PORT_CZYTNIK.byte == 0x01)
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1)
	BRNE _0x1E
; 0000 0328     {
; 0000 0329     macierz_zaciskow[rzad]=1;
	MOVW R30,R16
	CALL SUBOPT_0x13
	CALL SUBOPT_0x36
; 0000 032A     komunikat_z_czytnika_kodow("86-0170",rzad,1);
	__POINTW1FN _0x0,171
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 032B     }
; 0000 032C 
; 0000 032D if(PORT_CZYTNIK.byte == 0x02)
_0x1E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2)
	BRNE _0x1F
; 0000 032E     {
; 0000 032F     macierz_zaciskow[rzad]=2;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   X+,R30
	ST   X,R31
; 0000 0330     komunikat_z_czytnika_kodow("86-1043",rzad,0);
	__POINTW1FN _0x0,179
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 0331 
; 0000 0332     }
; 0000 0333 
; 0000 0334 if(PORT_CZYTNIK.byte == 0x03)
_0x1F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3)
	BRNE _0x20
; 0000 0335     {
; 0000 0336       macierz_zaciskow[rzad]=3;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   X+,R30
	ST   X,R31
; 0000 0337       komunikat_z_czytnika_kodow("86-1675",rzad,0);
	__POINTW1FN _0x0,187
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 0338     }
; 0000 0339 
; 0000 033A if(PORT_CZYTNIK.byte == 0x04)
_0x20:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4)
	BRNE _0x21
; 0000 033B     {
; 0000 033C 
; 0000 033D       macierz_zaciskow[rzad]=4;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	ST   X+,R30
	ST   X,R31
; 0000 033E       komunikat_z_czytnika_kodow("86-2098",rzad,0);
	__POINTW1FN _0x0,195
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 033F 
; 0000 0340     }
; 0000 0341 if(PORT_CZYTNIK.byte == 0x05)
_0x21:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5)
	BRNE _0x22
; 0000 0342     {
; 0000 0343       macierz_zaciskow[rzad]=5;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   X+,R30
	ST   X,R31
; 0000 0344       komunikat_z_czytnika_kodow("87-0170",rzad,0);
	__POINTW1FN _0x0,203
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 0345 
; 0000 0346     }
; 0000 0347 if(PORT_CZYTNIK.byte == 0x06)
_0x22:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6)
	BRNE _0x23
; 0000 0348     {
; 0000 0349       macierz_zaciskow[rzad]=6;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	ST   X+,R30
	ST   X,R31
; 0000 034A       komunikat_z_czytnika_kodow("87-1043",rzad,1);
	__POINTW1FN _0x0,211
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 034B 
; 0000 034C     }
; 0000 034D 
; 0000 034E if(PORT_CZYTNIK.byte == 0x07)
_0x23:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7)
	BRNE _0x24
; 0000 034F     {
; 0000 0350       macierz_zaciskow[rzad]=7;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	ST   X+,R30
	ST   X,R31
; 0000 0351       komunikat_z_czytnika_kodow("87-1675",rzad,1);
	__POINTW1FN _0x0,219
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 0352 
; 0000 0353     }
; 0000 0354 
; 0000 0355 if(PORT_CZYTNIK.byte == 0x08)
_0x24:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8)
	BRNE _0x25
; 0000 0356     {
; 0000 0357       macierz_zaciskow[rzad]=8;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   X+,R30
	ST   X,R31
; 0000 0358       komunikat_z_czytnika_kodow("87-2098",rzad,1);
	__POINTW1FN _0x0,227
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 0359 
; 0000 035A     }
; 0000 035B if(PORT_CZYTNIK.byte == 0x09)
_0x25:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x9)
	BRNE _0x26
; 0000 035C     {
; 0000 035D       macierz_zaciskow[rzad]=9;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	ST   X+,R30
	ST   X,R31
; 0000 035E       komunikat_z_czytnika_kodow("86-0192",rzad,0);
	__POINTW1FN _0x0,235
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 035F 
; 0000 0360     }
; 0000 0361 if(PORT_CZYTNIK.byte == 0x0A)
_0x26:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xA)
	BRNE _0x27
; 0000 0362     {
; 0000 0363       macierz_zaciskow[rzad]=10;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   X+,R30
	ST   X,R31
; 0000 0364       komunikat_z_czytnika_kodow("86-1054",rzad,0);
	__POINTW1FN _0x0,243
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 0365 
; 0000 0366     }
; 0000 0367 if(PORT_CZYTNIK.byte == 0x0B)
_0x27:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xB)
	BRNE _0x28
; 0000 0368     {
; 0000 0369       macierz_zaciskow[rzad]=11;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	ST   X+,R30
	ST   X,R31
; 0000 036A       komunikat_z_czytnika_kodow("86-1676",rzad,0);
	__POINTW1FN _0x0,251
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 036B 
; 0000 036C     }
; 0000 036D if(PORT_CZYTNIK.byte == 0x0C)
_0x28:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xC)
	BRNE _0x29
; 0000 036E     {
; 0000 036F       macierz_zaciskow[rzad]=12;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	ST   X+,R30
	ST   X,R31
; 0000 0370       komunikat_z_czytnika_kodow("86-2132",rzad,1);
	__POINTW1FN _0x0,259
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 0371 
; 0000 0372     }
; 0000 0373 if(PORT_CZYTNIK.byte == 0x0D)
_0x29:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xD)
	BRNE _0x2A
; 0000 0374     {
; 0000 0375       macierz_zaciskow[rzad]=13;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	ST   X+,R30
	ST   X,R31
; 0000 0376       komunikat_z_czytnika_kodow("87-0192",rzad,1);
	__POINTW1FN _0x0,267
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 0377 
; 0000 0378     }
; 0000 0379 if(PORT_CZYTNIK.byte == 0x0E)
_0x2A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xE)
	BRNE _0x2B
; 0000 037A     {
; 0000 037B       macierz_zaciskow[rzad]=14;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	ST   X+,R30
	ST   X,R31
; 0000 037C       komunikat_z_czytnika_kodow("87-1054",rzad,1);
	__POINTW1FN _0x0,275
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 037D 
; 0000 037E     }
; 0000 037F 
; 0000 0380 if(PORT_CZYTNIK.byte == 0x0F)
_0x2B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0xF)
	BRNE _0x2C
; 0000 0381     {
; 0000 0382       macierz_zaciskow[rzad]=15;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	ST   X+,R30
	ST   X,R31
; 0000 0383       komunikat_z_czytnika_kodow("87-1676",rzad,1);
	__POINTW1FN _0x0,283
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 0384 
; 0000 0385     }
; 0000 0386 if(PORT_CZYTNIK.byte == 0x10)
_0x2C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x10)
	BRNE _0x2D
; 0000 0387     {
; 0000 0388       macierz_zaciskow[rzad]=16;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	ST   X+,R30
	ST   X,R31
; 0000 0389       komunikat_z_czytnika_kodow("87-2132",rzad,0);
	__POINTW1FN _0x0,291
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 038A 
; 0000 038B     }
; 0000 038C 
; 0000 038D if(PORT_CZYTNIK.byte == 0x11)
_0x2D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x11)
	BRNE _0x2E
; 0000 038E     {
; 0000 038F       macierz_zaciskow[rzad]=17;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	ST   X+,R30
	ST   X,R31
; 0000 0390       komunikat_z_czytnika_kodow("86-0193",rzad,0);
	__POINTW1FN _0x0,299
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 0391     }
; 0000 0392 
; 0000 0393 if(PORT_CZYTNIK.byte == 0x12)
_0x2E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x12)
	BRNE _0x2F
; 0000 0394     {
; 0000 0395       macierz_zaciskow[rzad]=18;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	ST   X+,R30
	ST   X,R31
; 0000 0396       komunikat_z_czytnika_kodow("86-1216",rzad,0);
	__POINTW1FN _0x0,307
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 0397 
; 0000 0398     }
; 0000 0399 if(PORT_CZYTNIK.byte == 0x13)
_0x2F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x13)
	BRNE _0x30
; 0000 039A     {
; 0000 039B       macierz_zaciskow[rzad]=19;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(19)
	LDI  R31,HIGH(19)
	ST   X+,R30
	ST   X,R31
; 0000 039C       komunikat_z_czytnika_kodow("86-1832",rzad,0);
	__POINTW1FN _0x0,315
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 039D 
; 0000 039E     }
; 0000 039F 
; 0000 03A0 if(PORT_CZYTNIK.byte == 0x14)
_0x30:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x14)
	BRNE _0x31
; 0000 03A1     {
; 0000 03A2       macierz_zaciskow[rzad]=20;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	ST   X+,R30
	ST   X,R31
; 0000 03A3       komunikat_z_czytnika_kodow("86-2174",rzad,0);
	__POINTW1FN _0x0,323
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 03A4 
; 0000 03A5     }
; 0000 03A6 if(PORT_CZYTNIK.byte == 0x15)
_0x31:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x15)
	BRNE _0x32
; 0000 03A7     {
; 0000 03A8       macierz_zaciskow[rzad]=21;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(21)
	LDI  R31,HIGH(21)
	ST   X+,R30
	ST   X,R31
; 0000 03A9       komunikat_z_czytnika_kodow("87-0193",rzad,1);
	__POINTW1FN _0x0,331
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 03AA 
; 0000 03AB     }
; 0000 03AC 
; 0000 03AD if(PORT_CZYTNIK.byte == 0x16)
_0x32:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x16)
	BRNE _0x33
; 0000 03AE     {
; 0000 03AF       macierz_zaciskow[rzad]=22;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(22)
	LDI  R31,HIGH(22)
	ST   X+,R30
	ST   X,R31
; 0000 03B0       komunikat_z_czytnika_kodow("87-1216",rzad,1);
	__POINTW1FN _0x0,339
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 03B1 
; 0000 03B2     }
; 0000 03B3 if(PORT_CZYTNIK.byte == 0x17)
_0x33:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x17)
	BRNE _0x34
; 0000 03B4     {
; 0000 03B5       macierz_zaciskow[rzad]=23;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(23)
	LDI  R31,HIGH(23)
	ST   X+,R30
	ST   X,R31
; 0000 03B6       komunikat_z_czytnika_kodow("87-1832",rzad,1);
	__POINTW1FN _0x0,347
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 03B7 
; 0000 03B8     }
; 0000 03B9 
; 0000 03BA if(PORT_CZYTNIK.byte == 0x18)
_0x34:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x18)
	BRNE _0x35
; 0000 03BB     {
; 0000 03BC       macierz_zaciskow[rzad]=24;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	ST   X+,R30
	ST   X,R31
; 0000 03BD       komunikat_z_czytnika_kodow("87-2174",rzad,1);
	__POINTW1FN _0x0,355
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 03BE 
; 0000 03BF     }
; 0000 03C0 if(PORT_CZYTNIK.byte == 0x19)
_0x35:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x19)
	BRNE _0x36
; 0000 03C1     {
; 0000 03C2       macierz_zaciskow[rzad]=25;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	ST   X+,R30
	ST   X,R31
; 0000 03C3       komunikat_z_czytnika_kodow("86-0194",rzad,0);
	__POINTW1FN _0x0,363
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 03C4 
; 0000 03C5     }
; 0000 03C6 
; 0000 03C7 if(PORT_CZYTNIK.byte == 0x1A)
_0x36:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1A)
	BRNE _0x37
; 0000 03C8     {
; 0000 03C9       macierz_zaciskow[rzad]=26;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(26)
	LDI  R31,HIGH(26)
	ST   X+,R30
	ST   X,R31
; 0000 03CA       komunikat_z_czytnika_kodow("86-1341",rzad,0);
	__POINTW1FN _0x0,371
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 03CB 
; 0000 03CC     }
; 0000 03CD if(PORT_CZYTNIK.byte == 0x1B)
_0x37:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1B)
	BRNE _0x38
; 0000 03CE     {
; 0000 03CF       macierz_zaciskow[rzad]=27;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(27)
	LDI  R31,HIGH(27)
	ST   X+,R30
	ST   X,R31
; 0000 03D0       komunikat_z_czytnika_kodow("86-1833",rzad,0);
	__POINTW1FN _0x0,379
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 03D1 
; 0000 03D2     }
; 0000 03D3 if(PORT_CZYTNIK.byte == 0x1C)
_0x38:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1C)
	BRNE _0x39
; 0000 03D4     {
; 0000 03D5       macierz_zaciskow[rzad]=28;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(28)
	LDI  R31,HIGH(28)
	ST   X+,R30
	ST   X,R31
; 0000 03D6       komunikat_z_czytnika_kodow("86-2180",rzad,1);
	__POINTW1FN _0x0,387
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 03D7 
; 0000 03D8     }
; 0000 03D9 if(PORT_CZYTNIK.byte == 0x1D)
_0x39:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1D)
	BRNE _0x3A
; 0000 03DA     {
; 0000 03DB       macierz_zaciskow[rzad]=29;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(29)
	LDI  R31,HIGH(29)
	ST   X+,R30
	ST   X,R31
; 0000 03DC       komunikat_z_czytnika_kodow("87-0194",rzad,1);
	__POINTW1FN _0x0,395
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 03DD 
; 0000 03DE     }
; 0000 03DF 
; 0000 03E0 if(PORT_CZYTNIK.byte == 0x1E)
_0x3A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1E)
	BRNE _0x3B
; 0000 03E1     {
; 0000 03E2       macierz_zaciskow[rzad]=30;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	ST   X+,R30
	ST   X,R31
; 0000 03E3       komunikat_z_czytnika_kodow("87-1341",rzad,1);
	__POINTW1FN _0x0,403
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 03E4 
; 0000 03E5     }
; 0000 03E6 if(PORT_CZYTNIK.byte == 0x1F)
_0x3B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x1F)
	BRNE _0x3C
; 0000 03E7     {
; 0000 03E8       macierz_zaciskow[rzad]=31;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(31)
	LDI  R31,HIGH(31)
	ST   X+,R30
	ST   X,R31
; 0000 03E9       komunikat_z_czytnika_kodow("87-1833",rzad,1);
	__POINTW1FN _0x0,411
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 03EA 
; 0000 03EB     }
; 0000 03EC 
; 0000 03ED if(PORT_CZYTNIK.byte == 0x20)
_0x3C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x20)
	BRNE _0x3D
; 0000 03EE     {
; 0000 03EF       macierz_zaciskow[rzad]=32;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	ST   X+,R30
	ST   X,R31
; 0000 03F0       komunikat_z_czytnika_kodow("87-2180",rzad,0);
	__POINTW1FN _0x0,419
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 03F1 
; 0000 03F2     }
; 0000 03F3 if(PORT_CZYTNIK.byte == 0x21)
_0x3D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x21)
	BRNE _0x3E
; 0000 03F4     {
; 0000 03F5       macierz_zaciskow[rzad]=33;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(33)
	LDI  R31,HIGH(33)
	ST   X+,R30
	ST   X,R31
; 0000 03F6       komunikat_z_czytnika_kodow("86-0663",rzad,1);
	__POINTW1FN _0x0,427
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 03F7 
; 0000 03F8     }
; 0000 03F9 
; 0000 03FA if(PORT_CZYTNIK.byte == 0x22)
_0x3E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x22)
	BRNE _0x3F
; 0000 03FB     {
; 0000 03FC       macierz_zaciskow[rzad]=34;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(34)
	LDI  R31,HIGH(34)
	ST   X+,R30
	ST   X,R31
; 0000 03FD       komunikat_z_czytnika_kodow("86-1349",rzad,0);
	__POINTW1FN _0x0,435
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 03FE 
; 0000 03FF     }
; 0000 0400 if(PORT_CZYTNIK.byte == 0x23)
_0x3F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x23)
	BRNE _0x40
; 0000 0401     {
; 0000 0402       macierz_zaciskow[rzad]=35;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(35)
	LDI  R31,HIGH(35)
	ST   X+,R30
	ST   X,R31
; 0000 0403       komunikat_z_czytnika_kodow("86-1834",rzad,0);
	__POINTW1FN _0x0,443
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 0404 
; 0000 0405     }
; 0000 0406 if(PORT_CZYTNIK.byte == 0x24)
_0x40:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x24)
	BRNE _0x41
; 0000 0407     {
; 0000 0408       macierz_zaciskow[rzad]=36;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(36)
	LDI  R31,HIGH(36)
	ST   X+,R30
	ST   X,R31
; 0000 0409       komunikat_z_czytnika_kodow("86-2204",rzad,0);
	__POINTW1FN _0x0,451
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 040A 
; 0000 040B     }
; 0000 040C if(PORT_CZYTNIK.byte == 0x25)
_0x41:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x25)
	BRNE _0x42
; 0000 040D     {
; 0000 040E       macierz_zaciskow[rzad]=37;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(37)
	LDI  R31,HIGH(37)
	ST   X+,R30
	ST   X,R31
; 0000 040F       komunikat_z_czytnika_kodow("87-0663",rzad,0);
	__POINTW1FN _0x0,459
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 0410 
; 0000 0411     }
; 0000 0412 if(PORT_CZYTNIK.byte == 0x26)
_0x42:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x26)
	BRNE _0x43
; 0000 0413     {
; 0000 0414       macierz_zaciskow[rzad]=38;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(38)
	LDI  R31,HIGH(38)
	ST   X+,R30
	ST   X,R31
; 0000 0415       komunikat_z_czytnika_kodow("87-1349",rzad,1);
	__POINTW1FN _0x0,467
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 0416 
; 0000 0417     }
; 0000 0418 if(PORT_CZYTNIK.byte == 0x27)
_0x43:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x27)
	BRNE _0x44
; 0000 0419     {
; 0000 041A       macierz_zaciskow[rzad]=39;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(39)
	LDI  R31,HIGH(39)
	ST   X+,R30
	ST   X,R31
; 0000 041B       komunikat_z_czytnika_kodow("87-1834",rzad,1);
	__POINTW1FN _0x0,475
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 041C 
; 0000 041D     }
; 0000 041E if(PORT_CZYTNIK.byte == 0x28)
_0x44:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x28)
	BRNE _0x45
; 0000 041F     {
; 0000 0420       macierz_zaciskow[rzad]=40;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	ST   X+,R30
	ST   X,R31
; 0000 0421       komunikat_z_czytnika_kodow("87-2204",rzad,1);
	__POINTW1FN _0x0,483
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 0422 
; 0000 0423     }
; 0000 0424 if(PORT_CZYTNIK.byte == 0x29)
_0x45:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x29)
	BRNE _0x46
; 0000 0425     {
; 0000 0426       macierz_zaciskow[rzad]=41;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(41)
	LDI  R31,HIGH(41)
	ST   X+,R30
	ST   X,R31
; 0000 0427       komunikat_z_czytnika_kodow("86-0768",rzad,1);
	__POINTW1FN _0x0,491
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 0428 
; 0000 0429     }
; 0000 042A if(PORT_CZYTNIK.byte == 0x2A)
_0x46:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2A)
	BRNE _0x47
; 0000 042B     {
; 0000 042C       macierz_zaciskow[rzad]=42;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(42)
	LDI  R31,HIGH(42)
	ST   X+,R30
	ST   X,R31
; 0000 042D       komunikat_z_czytnika_kodow("86-1357",rzad,0);
	__POINTW1FN _0x0,499
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 042E 
; 0000 042F     }
; 0000 0430 if(PORT_CZYTNIK.byte == 0x2B)
_0x47:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2B)
	BRNE _0x48
; 0000 0431     {
; 0000 0432       macierz_zaciskow[rzad]=43;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(43)
	LDI  R31,HIGH(43)
	ST   X+,R30
	ST   X,R31
; 0000 0433       komunikat_z_czytnika_kodow("86-1848",rzad,0);
	__POINTW1FN _0x0,507
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 0434 
; 0000 0435     }
; 0000 0436 if(PORT_CZYTNIK.byte == 0x2C)
_0x48:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2C)
	BRNE _0x49
; 0000 0437     {
; 0000 0438      macierz_zaciskow[rzad]=44;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(44)
	LDI  R31,HIGH(44)
	CALL SUBOPT_0x39
; 0000 0439       macierz_zaciskow[rzad]=0;   ////////////////////////////////////////////////////brak zacisku
	CALL SUBOPT_0x3A
; 0000 043A 
; 0000 043B      komunikat_z_czytnika_kodow("86-2212",rzad,0);
	__POINTW1FN _0x0,515
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 043C 
; 0000 043D     }
; 0000 043E if(PORT_CZYTNIK.byte == 0x2D)
_0x49:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2D)
	BRNE _0x4A
; 0000 043F     {
; 0000 0440       macierz_zaciskow[rzad]=45;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(45)
	LDI  R31,HIGH(45)
	ST   X+,R30
	ST   X,R31
; 0000 0441       komunikat_z_czytnika_kodow("87-0768",rzad,0);
	__POINTW1FN _0x0,523
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 0442 
; 0000 0443     }
; 0000 0444 if(PORT_CZYTNIK.byte == 0x2E)
_0x4A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2E)
	BRNE _0x4B
; 0000 0445     {
; 0000 0446       macierz_zaciskow[rzad]=46;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(46)
	LDI  R31,HIGH(46)
	ST   X+,R30
	ST   X,R31
; 0000 0447       komunikat_z_czytnika_kodow("87-1357",rzad,1);
	__POINTW1FN _0x0,531
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 0448 
; 0000 0449     }
; 0000 044A if(PORT_CZYTNIK.byte == 0x2F)
_0x4B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x2F)
	BRNE _0x4C
; 0000 044B     {
; 0000 044C       macierz_zaciskow[rzad]=47;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(47)
	LDI  R31,HIGH(47)
	ST   X+,R30
	ST   X,R31
; 0000 044D       komunikat_z_czytnika_kodow("87-1848",rzad,1);
	__POINTW1FN _0x0,539
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 044E 
; 0000 044F     }
; 0000 0450 if(PORT_CZYTNIK.byte == 0x30)
_0x4C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x30)
	BRNE _0x4D
; 0000 0451     {
; 0000 0452       macierz_zaciskow[rzad]=48;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	CALL SUBOPT_0x39
; 0000 0453       macierz_zaciskow[rzad]=0;    /////////////////////////////////////////////////brak zacisku
	CALL SUBOPT_0x3A
; 0000 0454       komunikat_z_czytnika_kodow("87-2212",rzad,1);
	__POINTW1FN _0x0,547
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 0455 
; 0000 0456     }
; 0000 0457 if(PORT_CZYTNIK.byte == 0x31)
_0x4D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x31)
	BRNE _0x4E
; 0000 0458     {
; 0000 0459       macierz_zaciskow[rzad]=49;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(49)
	LDI  R31,HIGH(49)
	ST   X+,R30
	ST   X,R31
; 0000 045A       komunikat_z_czytnika_kodow("86-0800",rzad,0);
	__POINTW1FN _0x0,555
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 045B 
; 0000 045C     }
; 0000 045D if(PORT_CZYTNIK.byte == 0x32)
_0x4E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x32)
	BRNE _0x4F
; 0000 045E     {
; 0000 045F       macierz_zaciskow[rzad]=50;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   X+,R30
	ST   X,R31
; 0000 0460       komunikat_z_czytnika_kodow("86-1363",rzad,0);
	__POINTW1FN _0x0,563
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 0461 
; 0000 0462     }
; 0000 0463 if(PORT_CZYTNIK.byte == 0x33)
_0x4F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x33)
	BRNE _0x50
; 0000 0464     {
; 0000 0465       macierz_zaciskow[rzad]=51;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(51)
	LDI  R31,HIGH(51)
	ST   X+,R30
	ST   X,R31
; 0000 0466       komunikat_z_czytnika_kodow("86-1904",rzad,0);
	__POINTW1FN _0x0,571
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 0467 
; 0000 0468     }
; 0000 0469 if(PORT_CZYTNIK.byte == 0x34)
_0x50:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x34)
	BRNE _0x51
; 0000 046A     {
; 0000 046B       macierz_zaciskow[rzad]=52;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(52)
	LDI  R31,HIGH(52)
	ST   X+,R30
	ST   X,R31
; 0000 046C       komunikat_z_czytnika_kodow("86-2241",rzad,1);
	__POINTW1FN _0x0,579
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 046D 
; 0000 046E     }
; 0000 046F if(PORT_CZYTNIK.byte == 0x35)
_0x51:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x35)
	BRNE _0x52
; 0000 0470     {
; 0000 0471       macierz_zaciskow[rzad]=53;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(53)
	LDI  R31,HIGH(53)
	ST   X+,R30
	ST   X,R31
; 0000 0472       komunikat_z_czytnika_kodow("87-0800",rzad,1);
	__POINTW1FN _0x0,587
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 0473 
; 0000 0474     }
; 0000 0475 
; 0000 0476 if(PORT_CZYTNIK.byte == 0x36)
_0x52:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x36)
	BRNE _0x53
; 0000 0477     {
; 0000 0478       macierz_zaciskow[rzad]=54;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(54)
	LDI  R31,HIGH(54)
	ST   X+,R30
	ST   X,R31
; 0000 0479       komunikat_z_czytnika_kodow("87-1363",rzad,1);
	__POINTW1FN _0x0,595
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 047A 
; 0000 047B     }
; 0000 047C if(PORT_CZYTNIK.byte == 0x37)
_0x53:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x37)
	BRNE _0x54
; 0000 047D     {
; 0000 047E       macierz_zaciskow[rzad]=55;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(55)
	LDI  R31,HIGH(55)
	ST   X+,R30
	ST   X,R31
; 0000 047F       komunikat_z_czytnika_kodow("87-1904",rzad,1);
	__POINTW1FN _0x0,603
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 0480 
; 0000 0481     }
; 0000 0482 if(PORT_CZYTNIK.byte == 0x38)
_0x54:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x38)
	BRNE _0x55
; 0000 0483     {
; 0000 0484       macierz_zaciskow[rzad]=56;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(56)
	LDI  R31,HIGH(56)
	ST   X+,R30
	ST   X,R31
; 0000 0485       komunikat_z_czytnika_kodow("87-2241",rzad,0);
	__POINTW1FN _0x0,611
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 0486 
; 0000 0487     }
; 0000 0488 if(PORT_CZYTNIK.byte == 0x39)
_0x55:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x39)
	BRNE _0x56
; 0000 0489     {
; 0000 048A       macierz_zaciskow[rzad]=57;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(57)
	LDI  R31,HIGH(57)
	ST   X+,R30
	ST   X,R31
; 0000 048B       komunikat_z_czytnika_kodow("86-0811",rzad,0);
	__POINTW1FN _0x0,619
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 048C 
; 0000 048D     }
; 0000 048E if(PORT_CZYTNIK.byte == 0x3A)
_0x56:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3A)
	BRNE _0x57
; 0000 048F     {
; 0000 0490       macierz_zaciskow[rzad]=58;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(58)
	LDI  R31,HIGH(58)
	ST   X+,R30
	ST   X,R31
; 0000 0491       komunikat_z_czytnika_kodow("86-1523",rzad,0);
	__POINTW1FN _0x0,627
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 0492 
; 0000 0493     }
; 0000 0494 if(PORT_CZYTNIK.byte == 0x3B)
_0x57:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3B)
	BRNE _0x58
; 0000 0495     {
; 0000 0496       macierz_zaciskow[rzad]=59;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(59)
	LDI  R31,HIGH(59)
	ST   X+,R30
	ST   X,R31
; 0000 0497       komunikat_z_czytnika_kodow("86-1929",rzad,0);
	__POINTW1FN _0x0,635
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 0498 
; 0000 0499     }
; 0000 049A if(PORT_CZYTNIK.byte == 0x3C)
_0x58:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3C)
	BRNE _0x59
; 0000 049B     {
; 0000 049C       macierz_zaciskow[rzad]=60;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	ST   X+,R30
	ST   X,R31
; 0000 049D       komunikat_z_czytnika_kodow("86-2261",rzad,0);
	__POINTW1FN _0x0,643
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 049E 
; 0000 049F     }
; 0000 04A0 if(PORT_CZYTNIK.byte == 0x3D)
_0x59:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3D)
	BRNE _0x5A
; 0000 04A1     {
; 0000 04A2       macierz_zaciskow[rzad]=61;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(61)
	LDI  R31,HIGH(61)
	ST   X+,R30
	ST   X,R31
; 0000 04A3       komunikat_z_czytnika_kodow("87-0811",rzad,1);
	__POINTW1FN _0x0,651
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 04A4 
; 0000 04A5     }
; 0000 04A6 if(PORT_CZYTNIK.byte == 0x3E)
_0x5A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3E)
	BRNE _0x5B
; 0000 04A7     {
; 0000 04A8       macierz_zaciskow[rzad]=62;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(62)
	LDI  R31,HIGH(62)
	ST   X+,R30
	ST   X,R31
; 0000 04A9       komunikat_z_czytnika_kodow("87-1523",rzad,1);
	__POINTW1FN _0x0,659
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 04AA 
; 0000 04AB     }
; 0000 04AC if(PORT_CZYTNIK.byte == 0x3F)
_0x5B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x3F)
	BRNE _0x5C
; 0000 04AD     {
; 0000 04AE       macierz_zaciskow[rzad]=63;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(63)
	LDI  R31,HIGH(63)
	ST   X+,R30
	ST   X,R31
; 0000 04AF       komunikat_z_czytnika_kodow("87-1929",rzad,1);
	__POINTW1FN _0x0,667
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 04B0 
; 0000 04B1     }
; 0000 04B2 if(PORT_CZYTNIK.byte == 0x40)
_0x5C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x40)
	BRNE _0x5D
; 0000 04B3     {
; 0000 04B4       macierz_zaciskow[rzad]=64;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   X+,R30
	ST   X,R31
; 0000 04B5       komunikat_z_czytnika_kodow("87-2261",rzad,1);
	__POINTW1FN _0x0,675
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 04B6 
; 0000 04B7     }
; 0000 04B8 if(PORT_CZYTNIK.byte == 0x41)
_0x5D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x41)
	BRNE _0x5E
; 0000 04B9     {
; 0000 04BA       macierz_zaciskow[rzad]=65;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(65)
	LDI  R31,HIGH(65)
	ST   X+,R30
	ST   X,R31
; 0000 04BB       komunikat_z_czytnika_kodow("86-0814",rzad,0);
	__POINTW1FN _0x0,683
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 04BC 
; 0000 04BD     }
; 0000 04BE if(PORT_CZYTNIK.byte == 0x42)
_0x5E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x42)
	BRNE _0x5F
; 0000 04BF     {
; 0000 04C0       macierz_zaciskow[rzad]=66;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(66)
	LDI  R31,HIGH(66)
	ST   X+,R30
	ST   X,R31
; 0000 04C1       komunikat_z_czytnika_kodow("86-1530",rzad,1);
	__POINTW1FN _0x0,691
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 04C2 
; 0000 04C3     }
; 0000 04C4 if(PORT_CZYTNIK.byte == 0x43)
_0x5F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x43)
	BRNE _0x60
; 0000 04C5     {
; 0000 04C6       macierz_zaciskow[rzad]=67;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(67)
	LDI  R31,HIGH(67)
	ST   X+,R30
	ST   X,R31
; 0000 04C7       komunikat_z_czytnika_kodow("86-1936",rzad,1);
	__POINTW1FN _0x0,699
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 04C8 
; 0000 04C9     }
; 0000 04CA if(PORT_CZYTNIK.byte == 0x44)
_0x60:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x44)
	BRNE _0x61
; 0000 04CB     {
; 0000 04CC       macierz_zaciskow[rzad]=68;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	ST   X+,R30
	ST   X,R31
; 0000 04CD       komunikat_z_czytnika_kodow("86-2285",rzad,1);
	__POINTW1FN _0x0,707
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 04CE 
; 0000 04CF     }
; 0000 04D0 if(PORT_CZYTNIK.byte == 0x45)
_0x61:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x45)
	BRNE _0x62
; 0000 04D1     {
; 0000 04D2       macierz_zaciskow[rzad]=69;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(69)
	LDI  R31,HIGH(69)
	ST   X+,R30
	ST   X,R31
; 0000 04D3       komunikat_z_czytnika_kodow("87-0814",rzad,1);
	__POINTW1FN _0x0,715
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 04D4 
; 0000 04D5     }
; 0000 04D6 if(PORT_CZYTNIK.byte == 0x46)
_0x62:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x46)
	BRNE _0x63
; 0000 04D7     {
; 0000 04D8       macierz_zaciskow[rzad]=70;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	ST   X+,R30
	ST   X,R31
; 0000 04D9       komunikat_z_czytnika_kodow("87-1530",rzad,0);
	__POINTW1FN _0x0,723
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 04DA 
; 0000 04DB     }
; 0000 04DC if(PORT_CZYTNIK.byte == 0x47)
_0x63:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x47)
	BRNE _0x64
; 0000 04DD     {
; 0000 04DE       macierz_zaciskow[rzad]=71;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(71)
	LDI  R31,HIGH(71)
	ST   X+,R30
	ST   X,R31
; 0000 04DF       komunikat_z_czytnika_kodow("87-1936",rzad,0);
	__POINTW1FN _0x0,731
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 04E0 
; 0000 04E1     }
; 0000 04E2 if(PORT_CZYTNIK.byte == 0x48)
_0x64:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x48)
	BRNE _0x65
; 0000 04E3     {
; 0000 04E4       macierz_zaciskow[rzad]=72;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(72)
	LDI  R31,HIGH(72)
	ST   X+,R30
	ST   X,R31
; 0000 04E5       komunikat_z_czytnika_kodow("87-2285",rzad,0);
	__POINTW1FN _0x0,739
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 04E6 
; 0000 04E7     }
; 0000 04E8 if(PORT_CZYTNIK.byte == 0x49)
_0x65:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x49)
	BRNE _0x66
; 0000 04E9     {
; 0000 04EA       macierz_zaciskow[rzad]=73;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(73)
	LDI  R31,HIGH(73)
	ST   X+,R30
	ST   X,R31
; 0000 04EB       komunikat_z_czytnika_kodow("86-0815",rzad,0);
	__POINTW1FN _0x0,747
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 04EC 
; 0000 04ED     }
; 0000 04EE 
; 0000 04EF if(PORT_CZYTNIK.byte == 0x4A)
_0x66:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4A)
	BRNE _0x67
; 0000 04F0     {
; 0000 04F1       macierz_zaciskow[rzad]=74;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(74)
	LDI  R31,HIGH(74)
	ST   X+,R30
	ST   X,R31
; 0000 04F2       komunikat_z_czytnika_kodow("86-1551",rzad,0);
	__POINTW1FN _0x0,755
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 04F3 
; 0000 04F4     }
; 0000 04F5 if(PORT_CZYTNIK.byte == 0x4B)
_0x67:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4B)
	BRNE _0x68
; 0000 04F6     {
; 0000 04F7       macierz_zaciskow[rzad]=75;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(75)
	LDI  R31,HIGH(75)
	ST   X+,R30
	ST   X,R31
; 0000 04F8       komunikat_z_czytnika_kodow("86-1941",rzad,0);
	__POINTW1FN _0x0,763
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 04F9 
; 0000 04FA     }
; 0000 04FB if(PORT_CZYTNIK.byte == 0x4C)
_0x68:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4C)
	BRNE _0x69
; 0000 04FC     {
; 0000 04FD       macierz_zaciskow[rzad]=76;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(76)
	LDI  R31,HIGH(76)
	CALL SUBOPT_0x39
; 0000 04FE       macierz_zaciskow[rzad]=0;    ////////////////////////////////brak zacisku
	CALL SUBOPT_0x3A
; 0000 04FF       komunikat_z_czytnika_kodow("86-2286",rzad,0);
	__POINTW1FN _0x0,771
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 0500 
; 0000 0501     }
; 0000 0502 if(PORT_CZYTNIK.byte == 0x4D)
_0x69:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4D)
	BRNE _0x6A
; 0000 0503     {
; 0000 0504       macierz_zaciskow[rzad]=77;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(77)
	LDI  R31,HIGH(77)
	ST   X+,R30
	ST   X,R31
; 0000 0505       komunikat_z_czytnika_kodow("87-0815",rzad,1);
	__POINTW1FN _0x0,779
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 0506 
; 0000 0507     }
; 0000 0508 if(PORT_CZYTNIK.byte == 0x4E)
_0x6A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4E)
	BRNE _0x6B
; 0000 0509     {
; 0000 050A       macierz_zaciskow[rzad]=78;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(78)
	LDI  R31,HIGH(78)
	ST   X+,R30
	ST   X,R31
; 0000 050B       komunikat_z_czytnika_kodow("87-1551",rzad,1);
	__POINTW1FN _0x0,787
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 050C 
; 0000 050D     }
; 0000 050E if(PORT_CZYTNIK.byte == 0x4F)
_0x6B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x4F)
	BRNE _0x6C
; 0000 050F     {
; 0000 0510       macierz_zaciskow[rzad]=79;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(79)
	LDI  R31,HIGH(79)
	ST   X+,R30
	ST   X,R31
; 0000 0511       komunikat_z_czytnika_kodow("87-1941",rzad,1);
	__POINTW1FN _0x0,795
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 0512 
; 0000 0513     }
; 0000 0514 if(PORT_CZYTNIK.byte == 0x50)
_0x6C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x50)
	BRNE _0x6D
; 0000 0515     {
; 0000 0516       macierz_zaciskow[rzad]=80;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	CALL SUBOPT_0x39
; 0000 0517       macierz_zaciskow[rzad]=0;  ////////////////////////////////////////////////////////////////////////brak zacisku
	CALL SUBOPT_0x3A
; 0000 0518       komunikat_z_czytnika_kodow("87-2286",rzad,0);
	__POINTW1FN _0x0,803
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 0519 
; 0000 051A     }
; 0000 051B if(PORT_CZYTNIK.byte == 0x51)
_0x6D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x51)
	BRNE _0x6E
; 0000 051C     {
; 0000 051D       macierz_zaciskow[rzad]=81;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(81)
	LDI  R31,HIGH(81)
	ST   X+,R30
	ST   X,R31
; 0000 051E       komunikat_z_czytnika_kodow("86-0816",rzad,0);
	__POINTW1FN _0x0,811
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 051F 
; 0000 0520     }
; 0000 0521 if(PORT_CZYTNIK.byte == 0x52)
_0x6E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x52)
	BRNE _0x6F
; 0000 0522     {
; 0000 0523       macierz_zaciskow[rzad]=82;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(82)
	LDI  R31,HIGH(82)
	ST   X+,R30
	ST   X,R31
; 0000 0524       komunikat_z_czytnika_kodow("86-1552",rzad,0);
	__POINTW1FN _0x0,819
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 0525 
; 0000 0526     }
; 0000 0527 if(PORT_CZYTNIK.byte == 0x53)
_0x6F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x53)
	BRNE _0x70
; 0000 0528     {
; 0000 0529       macierz_zaciskow[rzad]=83;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(83)
	LDI  R31,HIGH(83)
	ST   X+,R30
	ST   X,R31
; 0000 052A       komunikat_z_czytnika_kodow("86-2007",rzad,1);
	__POINTW1FN _0x0,827
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 052B 
; 0000 052C     }
; 0000 052D if(PORT_CZYTNIK.byte == 0x54)
_0x70:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x54)
	BRNE _0x71
; 0000 052E     {
; 0000 052F       macierz_zaciskow[rzad]=84;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(84)
	LDI  R31,HIGH(84)
	ST   X+,R30
	ST   X,R31
; 0000 0530       komunikat_z_czytnika_kodow("86-2292",rzad,1);
	__POINTW1FN _0x0,835
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 0531 
; 0000 0532     }
; 0000 0533 if(PORT_CZYTNIK.byte == 0x55)
_0x71:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x55)
	BRNE _0x72
; 0000 0534     {
; 0000 0535       macierz_zaciskow[rzad]=85;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(85)
	LDI  R31,HIGH(85)
	ST   X+,R30
	ST   X,R31
; 0000 0536       komunikat_z_czytnika_kodow("87-0816",rzad,1);
	__POINTW1FN _0x0,843
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 0537 
; 0000 0538      }
; 0000 0539 if(PORT_CZYTNIK.byte == 0x56)
_0x72:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x56)
	BRNE _0x73
; 0000 053A     {
; 0000 053B       macierz_zaciskow[rzad]=86;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(86)
	LDI  R31,HIGH(86)
	ST   X+,R30
	ST   X,R31
; 0000 053C       komunikat_z_czytnika_kodow("87-1552",rzad,1);
	__POINTW1FN _0x0,851
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 053D 
; 0000 053E     }
; 0000 053F if(PORT_CZYTNIK.byte == 0x57)
_0x73:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x57)
	BRNE _0x74
; 0000 0540     {
; 0000 0541       macierz_zaciskow[rzad]=87;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(87)
	LDI  R31,HIGH(87)
	ST   X+,R30
	ST   X,R31
; 0000 0542       komunikat_z_czytnika_kodow("87-2007",rzad,0);
	__POINTW1FN _0x0,859
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 0543 
; 0000 0544     }
; 0000 0545 if(PORT_CZYTNIK.byte == 0x58)
_0x74:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x58)
	BRNE _0x75
; 0000 0546     {
; 0000 0547       macierz_zaciskow[rzad]=88;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(88)
	LDI  R31,HIGH(88)
	ST   X+,R30
	ST   X,R31
; 0000 0548       komunikat_z_czytnika_kodow("87-2292",rzad,0);
	__POINTW1FN _0x0,867
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 0549 
; 0000 054A     }
; 0000 054B if(PORT_CZYTNIK.byte == 0x59)
_0x75:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x59)
	BRNE _0x76
; 0000 054C     {
; 0000 054D       macierz_zaciskow[rzad]=89;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(89)
	LDI  R31,HIGH(89)
	ST   X+,R30
	ST   X,R31
; 0000 054E       komunikat_z_czytnika_kodow("86-0817",rzad,0);
	__POINTW1FN _0x0,875
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	RCALL _komunikat_z_czytnika_kodow
; 0000 054F 
; 0000 0550     }
; 0000 0551 if(PORT_CZYTNIK.byte == 0x5A)
_0x76:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5A)
	BRNE _0x77
; 0000 0552     {
; 0000 0553       macierz_zaciskow[rzad]=90;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	ST   X+,R30
	ST   X,R31
; 0000 0554       komunikat_z_czytnika_kodow("86-1602",rzad,1);
	__POINTW1FN _0x0,883
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 0555 
; 0000 0556     }
; 0000 0557 if(PORT_CZYTNIK.byte == 0x5B)
_0x77:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5B)
	BRNE _0x78
; 0000 0558     {
; 0000 0559       macierz_zaciskow[rzad]=91;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(91)
	LDI  R31,HIGH(91)
	ST   X+,R30
	ST   X,R31
; 0000 055A       komunikat_z_czytnika_kodow("86-2017",rzad,1);
	__POINTW1FN _0x0,891
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 055B 
; 0000 055C     }
; 0000 055D if(PORT_CZYTNIK.byte == 0x5C)
_0x78:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5C)
	BRNE _0x79
; 0000 055E     {
; 0000 055F       macierz_zaciskow[rzad]=92;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(92)
	LDI  R31,HIGH(92)
	CALL SUBOPT_0x39
; 0000 0560       macierz_zaciskow[rzad]=0;           /////////////////////////////////////////brak zacisku
	CALL SUBOPT_0x3A
; 0000 0561       komunikat_z_czytnika_kodow("86-2384",rzad,0);
	__POINTW1FN _0x0,899
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	CALL _komunikat_z_czytnika_kodow
; 0000 0562 
; 0000 0563     }
; 0000 0564 if(PORT_CZYTNIK.byte == 0x5D)
_0x79:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5D)
	BRNE _0x7A
; 0000 0565     {
; 0000 0566       macierz_zaciskow[rzad]=93;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(93)
	LDI  R31,HIGH(93)
	ST   X+,R30
	ST   X,R31
; 0000 0567       komunikat_z_czytnika_kodow("87-0817",rzad,1);
	__POINTW1FN _0x0,907
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 0568 
; 0000 0569     }
; 0000 056A if(PORT_CZYTNIK.byte == 0x5E)
_0x7A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5E)
	BRNE _0x7B
; 0000 056B     {
; 0000 056C       macierz_zaciskow[rzad]=94;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(94)
	LDI  R31,HIGH(94)
	ST   X+,R30
	ST   X,R31
; 0000 056D       komunikat_z_czytnika_kodow("87-1602",rzad,0);
	__POINTW1FN _0x0,915
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	CALL _komunikat_z_czytnika_kodow
; 0000 056E 
; 0000 056F     }
; 0000 0570 if(PORT_CZYTNIK.byte == 0x5F)
_0x7B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x5F)
	BRNE _0x7C
; 0000 0571     {
; 0000 0572       macierz_zaciskow[rzad]=95;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(95)
	LDI  R31,HIGH(95)
	ST   X+,R30
	ST   X,R31
; 0000 0573       komunikat_z_czytnika_kodow("87-2017",rzad,0);
	__POINTW1FN _0x0,923
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	CALL _komunikat_z_czytnika_kodow
; 0000 0574 
; 0000 0575     }
; 0000 0576 if(PORT_CZYTNIK.byte == 0x60)
_0x7C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x60)
	BRNE _0x7D
; 0000 0577     {
; 0000 0578       macierz_zaciskow[rzad]=96;   ///////////////////////////////////////////////brak zacisku
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(96)
	LDI  R31,HIGH(96)
	CALL SUBOPT_0x39
; 0000 0579       macierz_zaciskow[rzad]=0;
	CALL SUBOPT_0x3A
; 0000 057A       komunikat_z_czytnika_kodow("87-2384",rzad,0);
	__POINTW1FN _0x0,931
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	CALL _komunikat_z_czytnika_kodow
; 0000 057B 
; 0000 057C     }
; 0000 057D 
; 0000 057E if(PORT_CZYTNIK.byte == 0x61)
_0x7D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x61)
	BRNE _0x7E
; 0000 057F     {
; 0000 0580       macierz_zaciskow[rzad]=97;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(97)
	LDI  R31,HIGH(97)
	ST   X+,R30
	ST   X,R31
; 0000 0581       komunikat_z_czytnika_kodow("86-0847",rzad,0);
	__POINTW1FN _0x0,939
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	CALL _komunikat_z_czytnika_kodow
; 0000 0582 
; 0000 0583     }
; 0000 0584 
; 0000 0585 if(PORT_CZYTNIK.byte == 0x62)
_0x7E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x62)
	BRNE _0x7F
; 0000 0586     {
; 0000 0587       macierz_zaciskow[rzad]=98;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(98)
	LDI  R31,HIGH(98)
	ST   X+,R30
	ST   X,R31
; 0000 0588       komunikat_z_czytnika_kodow("86-1620",rzad,0);
	__POINTW1FN _0x0,947
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	CALL _komunikat_z_czytnika_kodow
; 0000 0589 
; 0000 058A     }
; 0000 058B if(PORT_CZYTNIK.byte == 0x63)
_0x7F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x63)
	BRNE _0x80
; 0000 058C     {
; 0000 058D       macierz_zaciskow[rzad]=99;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(99)
	LDI  R31,HIGH(99)
	ST   X+,R30
	ST   X,R31
; 0000 058E       komunikat_z_czytnika_kodow("86-2019",rzad,1);
	__POINTW1FN _0x0,955
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 058F 
; 0000 0590     }
; 0000 0591 if(PORT_CZYTNIK.byte == 0x64)
_0x80:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x64)
	BRNE _0x81
; 0000 0592     {
; 0000 0593       macierz_zaciskow[rzad]=100;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   X+,R30
	ST   X,R31
; 0000 0594       komunikat_z_czytnika_kodow("86-2385",rzad,0);
	__POINTW1FN _0x0,963
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	CALL _komunikat_z_czytnika_kodow
; 0000 0595 
; 0000 0596     }
; 0000 0597 if(PORT_CZYTNIK.byte == 0x65)
_0x81:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x65)
	BRNE _0x82
; 0000 0598     {
; 0000 0599       macierz_zaciskow[rzad]=101;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(101)
	LDI  R31,HIGH(101)
	ST   X+,R30
	ST   X,R31
; 0000 059A       komunikat_z_czytnika_kodow("87-0847",rzad,1);
	__POINTW1FN _0x0,971
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 059B 
; 0000 059C     }
; 0000 059D if(PORT_CZYTNIK.byte == 0x66)
_0x82:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x66)
	BRNE _0x83
; 0000 059E     {
; 0000 059F       macierz_zaciskow[rzad]=102;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(102)
	LDI  R31,HIGH(102)
	ST   X+,R30
	ST   X,R31
; 0000 05A0       komunikat_z_czytnika_kodow("87-1620",rzad,1);
	__POINTW1FN _0x0,979
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 05A1 
; 0000 05A2     }
; 0000 05A3 if(PORT_CZYTNIK.byte == 0x67)
_0x83:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x67)
	BRNE _0x84
; 0000 05A4     {
; 0000 05A5       macierz_zaciskow[rzad]=103;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(103)
	LDI  R31,HIGH(103)
	ST   X+,R30
	ST   X,R31
; 0000 05A6       komunikat_z_czytnika_kodow("87-2019",rzad,0);
	__POINTW1FN _0x0,987
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	CALL _komunikat_z_czytnika_kodow
; 0000 05A7 
; 0000 05A8     }
; 0000 05A9 if(PORT_CZYTNIK.byte == 0x68)
_0x84:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x68)
	BRNE _0x85
; 0000 05AA     {
; 0000 05AB       macierz_zaciskow[rzad]=104;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(104)
	LDI  R31,HIGH(104)
	ST   X+,R30
	ST   X,R31
; 0000 05AC       komunikat_z_czytnika_kodow("87-2385",rzad,1);
	__POINTW1FN _0x0,995
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 05AD 
; 0000 05AE     }
; 0000 05AF if(PORT_CZYTNIK.byte == 0x69)
_0x85:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x69)
	BRNE _0x86
; 0000 05B0     {
; 0000 05B1       macierz_zaciskow[rzad]=105;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(105)
	LDI  R31,HIGH(105)
	ST   X+,R30
	ST   X,R31
; 0000 05B2       komunikat_z_czytnika_kodow("86-0854",rzad,0);
	__POINTW1FN _0x0,1003
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	CALL _komunikat_z_czytnika_kodow
; 0000 05B3 
; 0000 05B4     }
; 0000 05B5 if(PORT_CZYTNIK.byte == 0x6A)
_0x86:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6A)
	BRNE _0x87
; 0000 05B6     {
; 0000 05B7       macierz_zaciskow[rzad]=106;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(106)
	LDI  R31,HIGH(106)
	ST   X+,R30
	ST   X,R31
; 0000 05B8       komunikat_z_czytnika_kodow("86-1622",rzad,1);
	__POINTW1FN _0x0,1011
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 05B9 
; 0000 05BA     }
; 0000 05BB if(PORT_CZYTNIK.byte == 0x6B)
_0x87:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6B)
	BRNE _0x88
; 0000 05BC     {
; 0000 05BD       macierz_zaciskow[rzad]=107;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(107)
	LDI  R31,HIGH(107)
	CALL SUBOPT_0x39
; 0000 05BE       macierz_zaciskow[rzad]=0;          //brak zacisku
	CALL SUBOPT_0x3A
; 0000 05BF       komunikat_z_czytnika_kodow("86-2028",rzad,0);
	__POINTW1FN _0x0,1019
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	CALL _komunikat_z_czytnika_kodow
; 0000 05C0 
; 0000 05C1     }
; 0000 05C2 if(PORT_CZYTNIK.byte == 0x6C)
_0x88:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6C)
	BRNE _0x89
; 0000 05C3     {
; 0000 05C4       macierz_zaciskow[rzad]=108;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(108)
	LDI  R31,HIGH(108)
	ST   X+,R30
	ST   X,R31
; 0000 05C5       komunikat_z_czytnika_kodow("86-2437",rzad,0);
	__POINTW1FN _0x0,1027
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	CALL _komunikat_z_czytnika_kodow
; 0000 05C6 
; 0000 05C7     }
; 0000 05C8 if(PORT_CZYTNIK.byte == 0x6D)
_0x89:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6D)
	BRNE _0x8A
; 0000 05C9     {
; 0000 05CA       macierz_zaciskow[rzad]=109;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(109)
	LDI  R31,HIGH(109)
	ST   X+,R30
	ST   X,R31
; 0000 05CB       komunikat_z_czytnika_kodow("87-0854",rzad,1);
	__POINTW1FN _0x0,1035
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 05CC 
; 0000 05CD     }
; 0000 05CE if(PORT_CZYTNIK.byte == 0x6E)
_0x8A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6E)
	BRNE _0x8B
; 0000 05CF     {
; 0000 05D0       macierz_zaciskow[rzad]=110;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(110)
	LDI  R31,HIGH(110)
	ST   X+,R30
	ST   X,R31
; 0000 05D1       komunikat_z_czytnika_kodow("87-1622",rzad,0);
	__POINTW1FN _0x0,1043
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	CALL _komunikat_z_czytnika_kodow
; 0000 05D2 
; 0000 05D3     }
; 0000 05D4 
; 0000 05D5 if(PORT_CZYTNIK.byte == 0x6F)
_0x8B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x6F)
	BRNE _0x8C
; 0000 05D6     {
; 0000 05D7       macierz_zaciskow[rzad]=111;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(111)
	LDI  R31,HIGH(111)
	CALL SUBOPT_0x39
; 0000 05D8       macierz_zaciskow[rzad]=0;      //brak zacisku
	CALL SUBOPT_0x3A
; 0000 05D9       komunikat_z_czytnika_kodow("87-2028",rzad,0);
	__POINTW1FN _0x0,1051
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	CALL _komunikat_z_czytnika_kodow
; 0000 05DA 
; 0000 05DB     }
; 0000 05DC 
; 0000 05DD if(PORT_CZYTNIK.byte == 0x70)
_0x8C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x70)
	BRNE _0x8D
; 0000 05DE     {
; 0000 05DF       macierz_zaciskow[rzad]=112;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(112)
	LDI  R31,HIGH(112)
	ST   X+,R30
	ST   X,R31
; 0000 05E0       komunikat_z_czytnika_kodow("87-2437",rzad,1);
	__POINTW1FN _0x0,1059
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 05E1 
; 0000 05E2     }
; 0000 05E3 if(PORT_CZYTNIK.byte == 0x71)
_0x8D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x71)
	BRNE _0x8E
; 0000 05E4     {
; 0000 05E5       macierz_zaciskow[rzad]=113;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(113)
	LDI  R31,HIGH(113)
	ST   X+,R30
	ST   X,R31
; 0000 05E6       komunikat_z_czytnika_kodow("86-0862",rzad,0);
	__POINTW1FN _0x0,1067
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	CALL _komunikat_z_czytnika_kodow
; 0000 05E7 
; 0000 05E8     }
; 0000 05E9 if(PORT_CZYTNIK.byte == 0x72)
_0x8E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x72)
	BRNE _0x8F
; 0000 05EA     {
; 0000 05EB       macierz_zaciskow[rzad]=114;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(114)
	LDI  R31,HIGH(114)
	ST   X+,R30
	ST   X,R31
; 0000 05EC       komunikat_z_czytnika_kodow("86-1625",rzad,0);
	__POINTW1FN _0x0,1075
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	CALL _komunikat_z_czytnika_kodow
; 0000 05ED 
; 0000 05EE     }
; 0000 05EF if(PORT_CZYTNIK.byte == 0x73)
_0x8F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x73)
	BRNE _0x90
; 0000 05F0     {
; 0000 05F1       macierz_zaciskow[rzad]=115;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(115)
	LDI  R31,HIGH(115)
	ST   X+,R30
	ST   X,R31
; 0000 05F2       komunikat_z_czytnika_kodow("86-2052",rzad,0);
	__POINTW1FN _0x0,1083
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	CALL _komunikat_z_czytnika_kodow
; 0000 05F3 
; 0000 05F4     }
; 0000 05F5 if(PORT_CZYTNIK.byte == 0x74)
_0x90:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x74)
	BRNE _0x91
; 0000 05F6     {
; 0000 05F7       macierz_zaciskow[rzad]=116;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(116)
	LDI  R31,HIGH(116)
	ST   X+,R30
	ST   X,R31
; 0000 05F8       komunikat_z_czytnika_kodow("86-2492",rzad,1);
	__POINTW1FN _0x0,1091
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 05F9 
; 0000 05FA     }
; 0000 05FB if(PORT_CZYTNIK.byte == 0x75)
_0x91:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x75)
	BRNE _0x92
; 0000 05FC     {
; 0000 05FD       macierz_zaciskow[rzad]=117;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(117)
	LDI  R31,HIGH(117)
	ST   X+,R30
	ST   X,R31
; 0000 05FE       komunikat_z_czytnika_kodow("87-0862",rzad,1);
	__POINTW1FN _0x0,1099
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 05FF 
; 0000 0600     }
; 0000 0601 if(PORT_CZYTNIK.byte == 0x76)
_0x92:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x76)
	BRNE _0x93
; 0000 0602     {
; 0000 0603       macierz_zaciskow[rzad]=118;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(118)
	LDI  R31,HIGH(118)
	ST   X+,R30
	ST   X,R31
; 0000 0604       komunikat_z_czytnika_kodow("87-1625",rzad,1);
	__POINTW1FN _0x0,1107
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 0605 
; 0000 0606     }
; 0000 0607 if(PORT_CZYTNIK.byte == 0x77)
_0x93:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x77)
	BRNE _0x94
; 0000 0608     {
; 0000 0609       macierz_zaciskow[rzad]=119;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(119)
	LDI  R31,HIGH(119)
	ST   X+,R30
	ST   X,R31
; 0000 060A       komunikat_z_czytnika_kodow("87-2052",rzad,1);
	__POINTW1FN _0x0,1115
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 060B 
; 0000 060C     }
; 0000 060D if(PORT_CZYTNIK.byte == 0x78)
_0x94:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x78)
	BRNE _0x95
; 0000 060E     {
; 0000 060F       macierz_zaciskow[rzad]=120;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	ST   X+,R30
	ST   X,R31
; 0000 0610       komunikat_z_czytnika_kodow("87-2492",rzad,0);
	__POINTW1FN _0x0,1123
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	CALL _komunikat_z_czytnika_kodow
; 0000 0611 
; 0000 0612     }
; 0000 0613 if(PORT_CZYTNIK.byte == 0x79)
_0x95:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x79)
	BRNE _0x96
; 0000 0614     {
; 0000 0615       macierz_zaciskow[rzad]=121;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(121)
	LDI  R31,HIGH(121)
	ST   X+,R30
	ST   X,R31
; 0000 0616       komunikat_z_czytnika_kodow("86-0935",rzad,0);
	__POINTW1FN _0x0,1131
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	CALL _komunikat_z_czytnika_kodow
; 0000 0617 
; 0000 0618     }
; 0000 0619 if(PORT_CZYTNIK.byte == 0x7A)
_0x96:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7A)
	BRNE _0x97
; 0000 061A     {
; 0000 061B       macierz_zaciskow[rzad]=122;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(122)
	LDI  R31,HIGH(122)
	ST   X+,R30
	ST   X,R31
; 0000 061C       komunikat_z_czytnika_kodow("86-1648",rzad,0);
	__POINTW1FN _0x0,1139
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	CALL _komunikat_z_czytnika_kodow
; 0000 061D 
; 0000 061E     }
; 0000 061F if(PORT_CZYTNIK.byte == 0x7B)
_0x97:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7B)
	BRNE _0x98
; 0000 0620     {
; 0000 0621       macierz_zaciskow[rzad]=123;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(123)
	LDI  R31,HIGH(123)
	ST   X+,R30
	ST   X,R31
; 0000 0622       komunikat_z_czytnika_kodow("86-2082",rzad,0);
	__POINTW1FN _0x0,1147
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	CALL _komunikat_z_czytnika_kodow
; 0000 0623 
; 0000 0624     }
; 0000 0625 if(PORT_CZYTNIK.byte == 0x7C)
_0x98:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7C)
	BRNE _0x99
; 0000 0626     {
; 0000 0627       macierz_zaciskow[rzad]=124;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(124)
	LDI  R31,HIGH(124)
	ST   X+,R30
	ST   X,R31
; 0000 0628       komunikat_z_czytnika_kodow("86-2500",rzad,0);
	__POINTW1FN _0x0,1155
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	CALL _komunikat_z_czytnika_kodow
; 0000 0629 
; 0000 062A     }
; 0000 062B if(PORT_CZYTNIK.byte == 0x7D)
_0x99:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7D)
	BRNE _0x9A
; 0000 062C     {
; 0000 062D       macierz_zaciskow[rzad]=125;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(125)
	LDI  R31,HIGH(125)
	ST   X+,R30
	ST   X,R31
; 0000 062E       komunikat_z_czytnika_kodow("87-0935",rzad,1);
	__POINTW1FN _0x0,1163
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 062F 
; 0000 0630     }
; 0000 0631 if(PORT_CZYTNIK.byte == 0x7E)
_0x9A:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7E)
	BRNE _0x9B
; 0000 0632     {
; 0000 0633       macierz_zaciskow[rzad]=126;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(126)
	LDI  R31,HIGH(126)
	ST   X+,R30
	ST   X,R31
; 0000 0634       komunikat_z_czytnika_kodow("87-1648",rzad,1);
	__POINTW1FN _0x0,1171
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 0635 
; 0000 0636     }
; 0000 0637 
; 0000 0638 if(PORT_CZYTNIK.byte == 0x7F)
_0x9B:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x7F)
	BRNE _0x9C
; 0000 0639     {
; 0000 063A       macierz_zaciskow[rzad]=127;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(127)
	LDI  R31,HIGH(127)
	ST   X+,R30
	ST   X,R31
; 0000 063B       komunikat_z_czytnika_kodow("87-2082",rzad,1);
	__POINTW1FN _0x0,1179
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 063C 
; 0000 063D     }
; 0000 063E if(PORT_CZYTNIK.byte == 0x80)
_0x9C:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x80)
	BRNE _0x9D
; 0000 063F     {
; 0000 0640       macierz_zaciskow[rzad]=128;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	ST   X+,R30
	ST   X,R31
; 0000 0641       komunikat_z_czytnika_kodow("87-2500",rzad,1);
	__POINTW1FN _0x0,1187
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 0642 
; 0000 0643     }
; 0000 0644 if(PORT_CZYTNIK.byte == 0x81)
_0x9D:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x81)
	BRNE _0x9E
; 0000 0645     {
; 0000 0646       macierz_zaciskow[rzad]=129;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(129)
	LDI  R31,HIGH(129)
	ST   X+,R30
	ST   X,R31
; 0000 0647       komunikat_z_czytnika_kodow("86-1019",rzad,0);
	__POINTW1FN _0x0,1195
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	CALL _komunikat_z_czytnika_kodow
; 0000 0648 
; 0000 0649     }
; 0000 064A if(PORT_CZYTNIK.byte == 0x82)
_0x9E:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x82)
	BRNE _0x9F
; 0000 064B     {
; 0000 064C       macierz_zaciskow[rzad]=130;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(130)
	LDI  R31,HIGH(130)
	ST   X+,R30
	ST   X,R31
; 0000 064D       komunikat_z_czytnika_kodow("86-1649",rzad,0);
	__POINTW1FN _0x0,1203
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	CALL _komunikat_z_czytnika_kodow
; 0000 064E 
; 0000 064F     }
; 0000 0650 if(PORT_CZYTNIK.byte == 0x83)
_0x9F:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x83)
	BRNE _0xA0
; 0000 0651     {
; 0000 0652       macierz_zaciskow[rzad]=131;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(131)
	LDI  R31,HIGH(131)
	ST   X+,R30
	ST   X,R31
; 0000 0653       komunikat_z_czytnika_kodow("86-2083",rzad,1);
	__POINTW1FN _0x0,1211
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 0654 
; 0000 0655     }
; 0000 0656 if(PORT_CZYTNIK.byte == 0x84)
_0xA0:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x84)
	BRNE _0xA1
; 0000 0657     {
; 0000 0658       macierz_zaciskow[rzad]=132;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(132)
	LDI  R31,HIGH(132)
	ST   X+,R30
	ST   X,R31
; 0000 0659       komunikat_z_czytnika_kodow("86-2585",rzad,0);
	__POINTW1FN _0x0,1219
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	CALL _komunikat_z_czytnika_kodow
; 0000 065A 
; 0000 065B     }
; 0000 065C if(PORT_CZYTNIK.byte == 0x85)
_0xA1:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x85)
	BRNE _0xA2
; 0000 065D     {
; 0000 065E       macierz_zaciskow[rzad]=133;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(133)
	LDI  R31,HIGH(133)
	ST   X+,R30
	ST   X,R31
; 0000 065F       komunikat_z_czytnika_kodow("87-1019",rzad,1);
	__POINTW1FN _0x0,1227
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 0660 
; 0000 0661     }
; 0000 0662 if(PORT_CZYTNIK.byte == 0x86)
_0xA2:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x86)
	BRNE _0xA3
; 0000 0663     {
; 0000 0664       macierz_zaciskow[rzad]=134;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(134)
	LDI  R31,HIGH(134)
	ST   X+,R30
	ST   X,R31
; 0000 0665       komunikat_z_czytnika_kodow("87-1649",rzad,1);
	__POINTW1FN _0x0,1235
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 0666 
; 0000 0667     }
; 0000 0668 if(PORT_CZYTNIK.byte == 0x87)
_0xA3:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x87)
	BRNE _0xA4
; 0000 0669     {
; 0000 066A       macierz_zaciskow[rzad]=135;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(135)
	LDI  R31,HIGH(135)
	ST   X+,R30
	ST   X,R31
; 0000 066B       komunikat_z_czytnika_kodow("87-2083",rzad,0);
	__POINTW1FN _0x0,1243
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	CALL _komunikat_z_czytnika_kodow
; 0000 066C 
; 0000 066D     }
; 0000 066E 
; 0000 066F if(PORT_CZYTNIK.byte == 0x88)
_0xA4:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x88)
	BRNE _0xA5
; 0000 0670     {
; 0000 0671       macierz_zaciskow[rzad]=136;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(136)
	LDI  R31,HIGH(136)
	ST   X+,R30
	ST   X,R31
; 0000 0672       komunikat_z_czytnika_kodow("87-2624",rzad,1);
	__POINTW1FN _0x0,1251
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 0673 
; 0000 0674     }
; 0000 0675 if(PORT_CZYTNIK.byte == 0x89)
_0xA5:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x89)
	BRNE _0xA6
; 0000 0676     {
; 0000 0677       macierz_zaciskow[rzad]=137;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(137)
	LDI  R31,HIGH(137)
	ST   X+,R30
	ST   X,R31
; 0000 0678       komunikat_z_czytnika_kodow("86-1027",rzad,0);
	__POINTW1FN _0x0,1259
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	CALL _komunikat_z_czytnika_kodow
; 0000 0679 
; 0000 067A     }
; 0000 067B if(PORT_CZYTNIK.byte == 0x8A)
_0xA6:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8A)
	BRNE _0xA7
; 0000 067C     {
; 0000 067D       macierz_zaciskow[rzad]=138;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(138)
	LDI  R31,HIGH(138)
	ST   X+,R30
	ST   X,R31
; 0000 067E       komunikat_z_czytnika_kodow("86-1669",rzad,1);
	__POINTW1FN _0x0,1267
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 067F 
; 0000 0680     }
; 0000 0681 if(PORT_CZYTNIK.byte == 0x8B)
_0xA7:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8B)
	BRNE _0xA8
; 0000 0682     {
; 0000 0683       macierz_zaciskow[rzad]=139;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(139)
	LDI  R31,HIGH(139)
	ST   X+,R30
	ST   X,R31
; 0000 0684       komunikat_z_czytnika_kodow("86-2087",rzad,1);
	__POINTW1FN _0x0,1275
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 0685 
; 0000 0686     }
; 0000 0687 if(PORT_CZYTNIK.byte == 0x8C)
_0xA8:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8C)
	BRNE _0xA9
; 0000 0688     {
; 0000 0689       macierz_zaciskow[rzad]=140;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(140)
	LDI  R31,HIGH(140)
	ST   X+,R30
	ST   X,R31
; 0000 068A       komunikat_z_czytnika_kodow("86-2624",rzad,0);
	__POINTW1FN _0x0,1283
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	CALL _komunikat_z_czytnika_kodow
; 0000 068B 
; 0000 068C     }
; 0000 068D if(PORT_CZYTNIK.byte == 0x8D)
_0xA9:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8D)
	BRNE _0xAA
; 0000 068E     {
; 0000 068F       macierz_zaciskow[rzad]=141;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(141)
	LDI  R31,HIGH(141)
	ST   X+,R30
	ST   X,R31
; 0000 0690       komunikat_z_czytnika_kodow("87-1027",rzad,1);
	__POINTW1FN _0x0,1291
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 0691 
; 0000 0692     }
; 0000 0693 if(PORT_CZYTNIK.byte == 0x8E)
_0xAA:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8E)
	BRNE _0xAB
; 0000 0694     {
; 0000 0695       macierz_zaciskow[rzad]=142;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(142)
	LDI  R31,HIGH(142)
	ST   X+,R30
	ST   X,R31
; 0000 0696       komunikat_z_czytnika_kodow("87-1669",rzad,0);
	__POINTW1FN _0x0,1299
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	CALL _komunikat_z_czytnika_kodow
; 0000 0697 
; 0000 0698     }
; 0000 0699 if(PORT_CZYTNIK.byte == 0x8F)
_0xAB:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x8F)
	BRNE _0xAC
; 0000 069A     {
; 0000 069B       macierz_zaciskow[rzad]=143;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(143)
	LDI  R31,HIGH(143)
	ST   X+,R30
	ST   X,R31
; 0000 069C       komunikat_z_czytnika_kodow("87-2087",rzad,0);
	__POINTW1FN _0x0,1307
	CALL SUBOPT_0x37
	CALL SUBOPT_0x24
	CALL _komunikat_z_czytnika_kodow
; 0000 069D 
; 0000 069E     }
; 0000 069F if(PORT_CZYTNIK.byte == 0x90)
_0xAC:
	LDS  R26,_PORT_CZYTNIK
	CPI  R26,LOW(0x90)
	BRNE _0xAD
; 0000 06A0     {
; 0000 06A1       macierz_zaciskow[rzad]=144;
	MOVW R30,R16
	CALL SUBOPT_0x13
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	ST   X+,R30
	ST   X,R31
; 0000 06A2       komunikat_z_czytnika_kodow("87-2585",rzad,1);
	__POINTW1FN _0x0,1315
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 06A3 
; 0000 06A4     }
; 0000 06A5 
; 0000 06A6 
; 0000 06A7 return rzad;
_0xAD:
	MOVW R30,R16
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 06A8 }
;
;
;void wybor_linijek_sterownikow(int rzad_local)
; 0000 06AC {
_wybor_linijek_sterownikow:
; 0000 06AD //zaczynam od tego
; 0000 06AE //komentarz: celowo upraszam:
; 0000 06AF //  a[2] = 0x22;    //ster4 ABS             //1,0,0,0,1,0  druciak    (1,0,0,0,1,0);
; 0000 06B0 //a[4] = 0x21;    //ster3 ABS             //krazek scierny
; 0000 06B1 
; 0000 06B2 //legenda pierwotna
; 0000 06B3             /*
; 0000 06B4             a[0] = 0x05A;   //ster1
; 0000 06B5             a[1] = a[0]+0x001;                                   //0x05B;   //ster2
; 0000 06B6             a[2] = 0x22;    //ster4 ABS             //1,0,0,0,1,0  druciak    (1,0,0,0,1,0);
; 0000 06B7             a[3] = 0x11;    //ster4 INV             //druciak
; 0000 06B8             a[4] = a[2];   //0x21;    //ster3 ABS             //krazek scierny
; 0000 06B9             a[5] = 0x196;   //delta okrag
; 0000 06BA             a[6] = a[5]+0x001;            //0x197;   //okrag
; 0000 06BB             a[7] = 0x12;    //ster3 INV             krazek scierny
; 0000 06BC             a[8] = a[6]+0x001;                0x198;   //-delta okrag
; 0000 06BD             a[9] = 0;          //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 06BE             */
; 0000 06BF 
; 0000 06C0 
; 0000 06C1 //macierz_zaciskow[rzad_local]
; 0000 06C2 //macierz_zaciskow[rzad_local] = 140;
; 0000 06C3 
; 0000 06C4 
; 0000 06C5 
; 0000 06C6 switch(macierz_zaciskow[rzad_local])
;	rzad_local -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	CALL SUBOPT_0x13
	CALL __GETW1P
; 0000 06C7 {
; 0000 06C8     case 0:
	SBIW R30,0
	BRNE _0xB1
; 0000 06C9 
; 0000 06CA             komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x31
; 0000 06CB             komunikat_na_panel("Nie wczytano zacisku",adr1,adr2);
	__POINTW1FN _0x0,1323
	CALL SUBOPT_0x3B
; 0000 06CC 
; 0000 06CD     break;
	JMP  _0xB0
; 0000 06CE 
; 0000 06CF 
; 0000 06D0      case 1:
_0xB1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xB2
; 0000 06D1 
; 0000 06D2             a[0] = 0x0C8;   //ster1
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CALL SUBOPT_0x3C
; 0000 06D3             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 06D4             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3E
; 0000 06D5             a[5] = 0x196;   //delta okrag
; 0000 06D6             a[7] = 0x11;    //ster3 INV krazek scierny
	JMP  _0x49B
; 0000 06D7             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 06D8 
; 0000 06D9             a[1] = a[0]+0x001;  //ster2
; 0000 06DA             a[2] = a[4];        //ster4 ABS druciak
; 0000 06DB             a[6] = a[5]+0x001;  //okrag
; 0000 06DC             a[8] = a[6]+0x001;  //-delta okrag
; 0000 06DD 
; 0000 06DE     break;
; 0000 06DF 
; 0000 06E0       case 2:
_0xB2:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xB3
; 0000 06E1 
; 0000 06E2             a[0] = 0x110;   //ster1
	LDI  R30,LOW(272)
	LDI  R31,HIGH(272)
	CALL SUBOPT_0x3C
; 0000 06E3             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3F
; 0000 06E4             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x40
; 0000 06E5             a[5] = 0x190;   //delta okrag
; 0000 06E6             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3F
; 0000 06E7             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x41
	JMP  _0x49C
; 0000 06E8 
; 0000 06E9             a[1] = a[0]+0x001;  //ster2
; 0000 06EA             a[2] = a[4];        //ster4 ABS druciak
; 0000 06EB             a[6] = a[5]+0x001;  //okrag
; 0000 06EC             a[8] = a[6]+0x001;  //-delta okrag
; 0000 06ED 
; 0000 06EE     break;
; 0000 06EF 
; 0000 06F0       case 3:
_0xB3:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xB4
; 0000 06F1 
; 0000 06F2             a[0] = 0x07A;   //ster1
	LDI  R30,LOW(122)
	LDI  R31,HIGH(122)
	CALL SUBOPT_0x3C
; 0000 06F3             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 06F4             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x42
; 0000 06F5             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x43
; 0000 06F6             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 06F7             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	JMP  _0x49C
; 0000 06F8 
; 0000 06F9             a[1] = a[0]+0x001;  //ster2
; 0000 06FA             a[2] = a[4];        //ster4 ABS druciak
; 0000 06FB             a[6] = a[5]+0x001;  //okrag
; 0000 06FC             a[8] = a[6]+0x001;  //-delta okrag
; 0000 06FD 
; 0000 06FE     break;
; 0000 06FF 
; 0000 0700       case 4:
_0xB4:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xB5
; 0000 0701 
; 0000 0702             a[0] = 0x102;   //ster1
	LDI  R30,LOW(258)
	LDI  R31,HIGH(258)
	CALL SUBOPT_0x3C
; 0000 0703             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0704             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x44
; 0000 0705             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x43
; 0000 0706             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0707             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	JMP  _0x49C
; 0000 0708 
; 0000 0709             a[1] = a[0]+0x001;  //ster2
; 0000 070A             a[2] = a[4];        //ster4 ABS druciak
; 0000 070B             a[6] = a[5]+0x001;  //okrag
; 0000 070C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 070D 
; 0000 070E     break;
; 0000 070F 
; 0000 0710       case 5:
_0xB5:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xB6
; 0000 0711 
; 0000 0712             a[0] = 0x0B0;   //ster1
	LDI  R30,LOW(176)
	LDI  R31,HIGH(176)
	CALL SUBOPT_0x3C
; 0000 0713             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0714             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3E
; 0000 0715             a[5] = 0x196;   //delta okrag
; 0000 0716             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x45
; 0000 0717             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0718 
; 0000 0719             a[1] = a[0]+0x001;  //ster2
; 0000 071A             a[2] = a[4];        //ster4 ABS druciak
; 0000 071B             a[6] = a[5]+0x001;  //okrag
; 0000 071C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 071D 
; 0000 071E     break;
; 0000 071F 
; 0000 0720       case 6:
_0xB6:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xB7
; 0000 0721 
; 0000 0722             a[0] = 0x0FE;   //ster1
	LDI  R30,LOW(254)
	LDI  R31,HIGH(254)
	CALL SUBOPT_0x3C
; 0000 0723             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3F
; 0000 0724             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x40
; 0000 0725             a[5] = 0x190;   //delta okrag
; 0000 0726             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x49B
; 0000 0727             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0728 
; 0000 0729             a[1] = a[0]+0x001;  //ster2
; 0000 072A             a[2] = a[4];        //ster4 ABS druciak
; 0000 072B             a[6] = a[5]+0x001;  //okrag
; 0000 072C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 072D 
; 0000 072E     break;
; 0000 072F 
; 0000 0730 
; 0000 0731       case 7:
_0xB7:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0xB8
; 0000 0732 
; 0000 0733             a[0] = 0x078;   //ster1
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	CALL SUBOPT_0x3C
; 0000 0734             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0735             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x42
; 0000 0736             a[5] = 0x196;   //delta okrag
	RJMP _0x49D
; 0000 0737             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0738             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0739 
; 0000 073A             a[1] = a[0]+0x001;  //ster2
; 0000 073B             a[2] = a[4];        //ster4 ABS druciak
; 0000 073C             a[6] = a[5]+0x001;  //okrag
; 0000 073D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 073E 
; 0000 073F     break;
; 0000 0740 
; 0000 0741 
; 0000 0742       case 8:
_0xB8:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0xB9
; 0000 0743 
; 0000 0744             a[0] = 0x0C0;   //ster1
	LDI  R30,LOW(192)
	LDI  R31,HIGH(192)
	CALL SUBOPT_0x3C
; 0000 0745             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0746             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x44
; 0000 0747             a[5] = 0x196;   //delta okrag
	RJMP _0x49D
; 0000 0748             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0749             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 074A 
; 0000 074B             a[1] = a[0]+0x001;  //ster2
; 0000 074C             a[2] = a[4];        //ster4 ABS druciak
; 0000 074D             a[6] = a[5]+0x001;  //okrag
; 0000 074E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 074F 
; 0000 0750     break;
; 0000 0751 
; 0000 0752 
; 0000 0753       case 9:
_0xB9:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0xBA
; 0000 0754 
; 0000 0755             a[0] = 0x018;   //ster1
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	CALL SUBOPT_0x3C
; 0000 0756             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0757             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x44
; 0000 0758             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x46
; 0000 0759             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x45
; 0000 075A             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 075B 
; 0000 075C             a[1] = a[0]+0x001;  //ster2
; 0000 075D             a[2] = a[4];        //ster4 ABS druciak
; 0000 075E             a[6] = a[5]+0x001;  //okrag
; 0000 075F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0760 
; 0000 0761     break;
; 0000 0762 
; 0000 0763 
; 0000 0764       case 10:
_0xBA:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0xBB
; 0000 0765 
; 0000 0766             a[0] = 0x016;   //ster1
	LDI  R30,LOW(22)
	LDI  R31,HIGH(22)
	CALL SUBOPT_0x3C
; 0000 0767             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0768             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x47
; 0000 0769             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x43
; 0000 076A             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 076B             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 076C 
; 0000 076D             a[1] = a[0]+0x001;  //ster2
; 0000 076E             a[2] = a[4];        //ster4 ABS druciak
; 0000 076F             a[6] = a[5]+0x001;  //okrag
; 0000 0770             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0771 
; 0000 0772     break;
; 0000 0773 
; 0000 0774 
; 0000 0775       case 11:
_0xBB:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0xBC
; 0000 0776 
; 0000 0777             a[0] = 0x074;   //ster1
	LDI  R30,LOW(116)
	LDI  R31,HIGH(116)
	CALL SUBOPT_0x3C
; 0000 0778             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0779             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x48
; 0000 077A             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x43
; 0000 077B             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 077C             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 077D 
; 0000 077E             a[1] = a[0]+0x001;  //ster2
; 0000 077F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0780             a[6] = a[5]+0x001;  //okrag
; 0000 0781             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0782 
; 0000 0783     break;
; 0000 0784 
; 0000 0785 
; 0000 0786       case 12:
_0xBC:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0xBD
; 0000 0787 
; 0000 0788             a[0] = 0x096;   //ster1
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	CALL SUBOPT_0x3C
; 0000 0789             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 078A             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x49
; 0000 078B             a[5] = 0x199;   //delta okrag
	RJMP _0x49D
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
; 0000 0797       case 13:
_0xBD:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0xBE
; 0000 0798 
; 0000 0799             a[0] = 0x01A;   //ster1
	LDI  R30,LOW(26)
	LDI  R31,HIGH(26)
	CALL SUBOPT_0x3C
; 0000 079A             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 079B             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x44
; 0000 079C             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x46
; 0000 079D             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x49B
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
; 0000 07A8       case 14:
_0xBE:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0xBF
; 0000 07A9 
; 0000 07AA             a[0] = 0x05E;   //ster1
	LDI  R30,LOW(94)
	LDI  R31,HIGH(94)
	CALL SUBOPT_0x3C
; 0000 07AB             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 07AC             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x47
; 0000 07AD             a[5] = 0x199;   //delta okrag
	RJMP _0x49D
; 0000 07AE             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 07AF             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 07B0 
; 0000 07B1             a[1] = a[0]+0x001;  //ster2
; 0000 07B2             a[2] = a[4];        //ster4 ABS druciak
; 0000 07B3             a[6] = a[5]+0x001;  //okrag
; 0000 07B4             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07B5 
; 0000 07B6     break;
; 0000 07B7 
; 0000 07B8 
; 0000 07B9       case 15:
_0xBF:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0xC0
; 0000 07BA 
; 0000 07BB             a[0] = 0x084;   //ster1
	LDI  R30,LOW(132)
	LDI  R31,HIGH(132)
	CALL SUBOPT_0x3C
; 0000 07BC             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 07BD             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x48
; 0000 07BE             a[5] = 0x199;   //delta okrag
	RJMP _0x49D
; 0000 07BF             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 07C0             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 07C1 
; 0000 07C2             a[1] = a[0]+0x001;  //ster2
; 0000 07C3             a[2] = a[4];        //ster4 ABS druciak
; 0000 07C4             a[6] = a[5]+0x001;  //okrag
; 0000 07C5             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07C6 
; 0000 07C7     break;
; 0000 07C8 
; 0000 07C9 
; 0000 07CA       case 16:
_0xC0:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0xC1
; 0000 07CB 
; 0000 07CC             a[0] = 0x0B8;   //ster1
	LDI  R30,LOW(184)
	LDI  R31,HIGH(184)
	CALL SUBOPT_0x3C
; 0000 07CD             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 07CE             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4A
; 0000 07CF             a[5] = 0x199;   //delta okrag
; 0000 07D0             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 07D1             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 07D2 
; 0000 07D3             a[1] = a[0]+0x001;  //ster2
; 0000 07D4             a[2] = a[4];        //ster4 ABS druciak
; 0000 07D5             a[6] = a[5]+0x001;  //okrag
; 0000 07D6             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07D7 
; 0000 07D8     break;
; 0000 07D9 
; 0000 07DA       case 17:
_0xC1:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0xC2
; 0000 07DB 
; 0000 07DC             a[0] = 0x020;   //ster1
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	CALL SUBOPT_0x3C
; 0000 07DD             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 07DE             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3E
; 0000 07DF             a[5] = 0x196;   //delta okrag
; 0000 07E0             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x45
; 0000 07E1             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 07E2 
; 0000 07E3             a[1] = a[0]+0x001;  //ster2
; 0000 07E4             a[2] = a[4];        //ster4 ABS druciak
; 0000 07E5             a[6] = a[5]+0x001;  //okrag
; 0000 07E6             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07E7 
; 0000 07E8     break;
; 0000 07E9 
; 0000 07EA 
; 0000 07EB       case 18:
_0xC2:
	CPI  R30,LOW(0x12)
	LDI  R26,HIGH(0x12)
	CPC  R31,R26
	BRNE _0xC3
; 0000 07EC 
; 0000 07ED             a[0] = 0x098;   //ster1
	LDI  R30,LOW(152)
	LDI  R31,HIGH(152)
	CALL SUBOPT_0x3C
; 0000 07EE             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3F
; 0000 07EF             a[4] = 0x16;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4B
; 0000 07F0             a[5] = 0x190;   //delta okrag
; 0000 07F1             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3F
; 0000 07F2             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x41
	RJMP _0x49C
; 0000 07F3 
; 0000 07F4             a[1] = a[0]+0x001;  //ster2
; 0000 07F5             a[2] = a[4];        //ster4 ABS druciak
; 0000 07F6             a[6] = a[5]+0x001;  //okrag
; 0000 07F7             a[8] = a[6]+0x001;  //-delta okrag
; 0000 07F8 
; 0000 07F9     break;
; 0000 07FA 
; 0000 07FB 
; 0000 07FC 
; 0000 07FD       case 19:
_0xC3:
	CPI  R30,LOW(0x13)
	LDI  R26,HIGH(0x13)
	CPC  R31,R26
	BRNE _0xC4
; 0000 07FE 
; 0000 07FF             a[0] = 0x0AA;   //ster1
	LDI  R30,LOW(170)
	LDI  R31,HIGH(170)
	CALL SUBOPT_0x3C
; 0000 0800             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0801             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4C
; 0000 0802             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x4D
; 0000 0803             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0804             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0805 
; 0000 0806             a[1] = a[0]+0x001;  //ster2
; 0000 0807             a[2] = a[4];        //ster4 ABS druciak
; 0000 0808             a[6] = a[5]+0x001;  //okrag
; 0000 0809             a[8] = a[6]+0x001;  //-delta okrag
; 0000 080A 
; 0000 080B     break;
; 0000 080C 
; 0000 080D 
; 0000 080E       case 20:
_0xC4:
	CPI  R30,LOW(0x14)
	LDI  R26,HIGH(0x14)
	CPC  R31,R26
	BRNE _0xC5
; 0000 080F 
; 0000 0810             a[0] = 0x042;   //ster1
	LDI  R30,LOW(66)
	LDI  R31,HIGH(66)
	CALL SUBOPT_0x3C
; 0000 0811             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0812             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4C
; 0000 0813             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x4E
; 0000 0814             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x45
; 0000 0815             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0816 
; 0000 0817             a[1] = a[0]+0x001;  //ster2
; 0000 0818             a[2] = a[4];        //ster4 ABS druciak
; 0000 0819             a[6] = a[5]+0x001;  //okrag
; 0000 081A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 081B 
; 0000 081C     break;
; 0000 081D 
; 0000 081E 
; 0000 081F       case 21:
_0xC5:
	CPI  R30,LOW(0x15)
	LDI  R26,HIGH(0x15)
	CPC  R31,R26
	BRNE _0xC6
; 0000 0820 
; 0000 0821             a[0] = 0x04E;   //ster1
	LDI  R30,LOW(78)
	LDI  R31,HIGH(78)
	CALL SUBOPT_0x3C
; 0000 0822             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0823             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3E
; 0000 0824             a[5] = 0x196;   //delta okrag
; 0000 0825             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x49B
; 0000 0826             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0827 
; 0000 0828             a[1] = a[0]+0x001;  //ster2
; 0000 0829             a[2] = a[4];        //ster4 ABS druciak
; 0000 082A             a[6] = a[5]+0x001;  //okrag
; 0000 082B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 082C 
; 0000 082D     break;
; 0000 082E 
; 0000 082F       case 22:
_0xC6:
	CPI  R30,LOW(0x16)
	LDI  R26,HIGH(0x16)
	CPC  R31,R26
	BRNE _0xC7
; 0000 0830 
; 0000 0831             a[0] = 0x0C2;   //ster1
	LDI  R30,LOW(194)
	LDI  R31,HIGH(194)
	CALL SUBOPT_0x3C
; 0000 0832             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3F
; 0000 0833             a[4] = 0x16;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4B
; 0000 0834             a[5] = 0x190;   //delta okrag
; 0000 0835             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x49B
; 0000 0836             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0837 
; 0000 0838             a[1] = a[0]+0x001;  //ster2
; 0000 0839             a[2] = a[4];        //ster4 ABS druciak
; 0000 083A             a[6] = a[5]+0x001;  //okrag
; 0000 083B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 083C 
; 0000 083D     break;
; 0000 083E 
; 0000 083F 
; 0000 0840       case 23:
_0xC7:
	CPI  R30,LOW(0x17)
	LDI  R26,HIGH(0x17)
	CPC  R31,R26
	BRNE _0xC8
; 0000 0841 
; 0000 0842             a[0] = 0x0CE;   //ster1
	LDI  R30,LOW(206)
	LDI  R31,HIGH(206)
	CALL SUBOPT_0x3C
; 0000 0843             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0844             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4C
; 0000 0845             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x49D
; 0000 0846             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0847             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0848 
; 0000 0849             a[1] = a[0]+0x001;  //ster2
; 0000 084A             a[2] = a[4];        //ster4 ABS druciak
; 0000 084B             a[6] = a[5]+0x001;  //okrag
; 0000 084C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 084D 
; 0000 084E     break;
; 0000 084F 
; 0000 0850 
; 0000 0851       case 24:
_0xC8:
	CPI  R30,LOW(0x18)
	LDI  R26,HIGH(0x18)
	CPC  R31,R26
	BRNE _0xC9
; 0000 0852 
; 0000 0853             a[0] = 0x040;   //ster1
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	CALL SUBOPT_0x3C
; 0000 0854             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0855             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4C
; 0000 0856             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x4E
; 0000 0857             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x49B
; 0000 0858             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0859 
; 0000 085A             a[1] = a[0]+0x001;  //ster2
; 0000 085B             a[2] = a[4];        //ster4 ABS druciak
; 0000 085C             a[6] = a[5]+0x001;  //okrag
; 0000 085D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 085E 
; 0000 085F     break;
; 0000 0860 
; 0000 0861       case 25:
_0xC9:
	CPI  R30,LOW(0x19)
	LDI  R26,HIGH(0x19)
	CPC  R31,R26
	BRNE _0xCA
; 0000 0862 
; 0000 0863             a[0] = 0x02E;   //ster1
	LDI  R30,LOW(46)
	LDI  R31,HIGH(46)
	CALL SUBOPT_0x3C
; 0000 0864             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0865             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x47
; 0000 0866             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x43
; 0000 0867             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0868             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0869 
; 0000 086A             a[1] = a[0]+0x001;  //ster2
; 0000 086B             a[2] = a[4];        //ster4 ABS druciak
; 0000 086C             a[6] = a[5]+0x001;  //okrag
; 0000 086D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 086E 
; 0000 086F     break;
; 0000 0870 
; 0000 0871       case 26:
_0xCA:
	CPI  R30,LOW(0x1A)
	LDI  R26,HIGH(0x1A)
	CPC  R31,R26
	BRNE _0xCB
; 0000 0872 
; 0000 0873             a[0] = 0x0FA;   //ster1
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x3C
; 0000 0874             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0875             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4F
; 0000 0876             a[5] = 0x190;   //delta okrag
; 0000 0877             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x45
; 0000 0878             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0879 
; 0000 087A             a[1] = a[0]+0x001;  //ster2
; 0000 087B             a[2] = a[4];        //ster4 ABS druciak
; 0000 087C             a[6] = a[5]+0x001;  //okrag
; 0000 087D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 087E 
; 0000 087F     break;
; 0000 0880 
; 0000 0881 
; 0000 0882       case 27:
_0xCB:
	CPI  R30,LOW(0x1B)
	LDI  R26,HIGH(0x1B)
	CPC  R31,R26
	BRNE _0xCC
; 0000 0883 
; 0000 0884             a[0] = 0x06C;   //ster1
	LDI  R30,LOW(108)
	LDI  R31,HIGH(108)
	CALL SUBOPT_0x3C
; 0000 0885             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0886             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4A
; 0000 0887             a[5] = 0x199;   //delta okrag
; 0000 0888             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0889             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 088A 
; 0000 088B             a[1] = a[0]+0x001;  //ster2
; 0000 088C             a[2] = a[4];        //ster4 ABS druciak
; 0000 088D             a[6] = a[5]+0x001;  //okrag
; 0000 088E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 088F 
; 0000 0890     break;
; 0000 0891 
; 0000 0892 
; 0000 0893       case 28:
_0xCC:
	CPI  R30,LOW(0x1C)
	LDI  R26,HIGH(0x1C)
	CPC  R31,R26
	BRNE _0xCD
; 0000 0894 
; 0000 0895             a[0] = 0x0A4;   //ster1
	LDI  R30,LOW(164)
	LDI  R31,HIGH(164)
	CALL SUBOPT_0x3C
; 0000 0896             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0897             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x49
; 0000 0898             a[5] = 0x199;   //delta okrag
	RJMP _0x49D
; 0000 0899             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 089A             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 089B 
; 0000 089C             a[1] = a[0]+0x001;  //ster2
; 0000 089D             a[2] = a[4];        //ster4 ABS druciak
; 0000 089E             a[6] = a[5]+0x001;  //okrag
; 0000 089F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08A0 
; 0000 08A1     break;
; 0000 08A2 
; 0000 08A3       case 29:
_0xCD:
	CPI  R30,LOW(0x1D)
	LDI  R26,HIGH(0x1D)
	CPC  R31,R26
	BRNE _0xCE
; 0000 08A4 
; 0000 08A5             a[0] = 0x02A;   //ster1
	LDI  R30,LOW(42)
	LDI  R31,HIGH(42)
	CALL SUBOPT_0x3C
; 0000 08A6             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 08A7             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x47
; 0000 08A8             a[5] = 0x199;   //delta okrag
	RJMP _0x49D
; 0000 08A9             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 08AA             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 08AB 
; 0000 08AC             a[1] = a[0]+0x001;  //ster2
; 0000 08AD             a[2] = a[4];        //ster4 ABS druciak
; 0000 08AE             a[6] = a[5]+0x001;  //okrag
; 0000 08AF             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08B0 
; 0000 08B1     break;
; 0000 08B2 
; 0000 08B3       case 30:
_0xCE:
	CPI  R30,LOW(0x1E)
	LDI  R26,HIGH(0x1E)
	CPC  R31,R26
	BRNE _0xCF
; 0000 08B4 
; 0000 08B5             a[0] = 0x094;   //ster1
	LDI  R30,LOW(148)
	LDI  R31,HIGH(148)
	CALL SUBOPT_0x3C
; 0000 08B6             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 08B7             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4F
; 0000 08B8             a[5] = 0x190;   //delta okrag
; 0000 08B9             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x49B
; 0000 08BA             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 08BB 
; 0000 08BC             a[1] = a[0]+0x001;  //ster2
; 0000 08BD             a[2] = a[4];        //ster4 ABS druciak
; 0000 08BE             a[6] = a[5]+0x001;  //okrag
; 0000 08BF             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08C0 
; 0000 08C1     break;
; 0000 08C2 
; 0000 08C3       case 31:
_0xCF:
	CPI  R30,LOW(0x1F)
	LDI  R26,HIGH(0x1F)
	CPC  R31,R26
	BRNE _0xD0
; 0000 08C4 
; 0000 08C5             a[0] = 0x06E;   //ster1
	LDI  R30,LOW(110)
	LDI  R31,HIGH(110)
	CALL SUBOPT_0x3C
; 0000 08C6             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 08C7             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x50
; 0000 08C8             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x49D
; 0000 08C9             a[7] = 0x12;  //ster3 INV krazek scierny
; 0000 08CA             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 08CB 
; 0000 08CC             a[1] = a[0]+0x001;  //ster2
; 0000 08CD             a[2] = a[4];        //ster4 ABS druciak
; 0000 08CE             a[6] = a[5]+0x001;  //okrag
; 0000 08CF             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08D0 
; 0000 08D1     break;
; 0000 08D2 
; 0000 08D3 
; 0000 08D4        case 32:
_0xD0:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BRNE _0xD1
; 0000 08D5 
; 0000 08D6             a[0] = 0x086;   //ster1
	LDI  R30,LOW(134)
	LDI  R31,HIGH(134)
	CALL SUBOPT_0x3C
; 0000 08D7             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 08D8             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x49
; 0000 08D9             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x43
; 0000 08DA             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 08DB             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 08DC 
; 0000 08DD             a[1] = a[0]+0x001;  //ster2
; 0000 08DE             a[2] = a[4];        //ster4 ABS druciak
; 0000 08DF             a[6] = a[5]+0x001;  //okrag
; 0000 08E0             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08E1 
; 0000 08E2     break;
; 0000 08E3 
; 0000 08E4        case 33:
_0xD1:
	CPI  R30,LOW(0x21)
	LDI  R26,HIGH(0x21)
	CPC  R31,R26
	BRNE _0xD2
; 0000 08E5 
; 0000 08E6             a[0] = 0x08E;   //ster1
	LDI  R30,LOW(142)
	LDI  R31,HIGH(142)
	CALL SUBOPT_0x3C
; 0000 08E7             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 08E8             a[4] = 0x20;    //ster3 ABS krazek scierny
	LDI  R26,LOW(32)
	LDI  R27,HIGH(32)
	RJMP _0x49E
; 0000 08E9             a[5] = 0x19C;   //delta okrag
; 0000 08EA             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 08EB             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 08EC 
; 0000 08ED             a[1] = a[0]+0x001;  //ster2
; 0000 08EE             a[2] = a[4];        //ster4 ABS druciak
; 0000 08EF             a[6] = a[5]+0x001;  //okrag
; 0000 08F0             a[8] = a[6]+0x001;  //-delta okrag
; 0000 08F1 
; 0000 08F2     break;
; 0000 08F3 
; 0000 08F4 
; 0000 08F5     case 34: //86-1349
_0xD2:
	CPI  R30,LOW(0x22)
	LDI  R26,HIGH(0x22)
	CPC  R31,R26
	BRNE _0xD3
; 0000 08F6 
; 0000 08F7             a[0] = 0x05A;   //ster1
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	CALL SUBOPT_0x3C
; 0000 08F8             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 08F9             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x51
; 0000 08FA             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x52
; 0000 08FB             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 08FC             a[9] = 0;       //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 08FD 
; 0000 08FE             a[1] = a[0]+0x001;  //ster2
; 0000 08FF             a[2] = a[4];        //ster4 ABS druciak
; 0000 0900             a[6] = a[5]+0x001;  //okrag
; 0000 0901             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0902 
; 0000 0903     break;
; 0000 0904 
; 0000 0905 
; 0000 0906     case 35:
_0xD3:
	CPI  R30,LOW(0x23)
	LDI  R26,HIGH(0x23)
	CPC  R31,R26
	BRNE _0xD4
; 0000 0907 
; 0000 0908             a[0] = 0x0DA;   //ster1
	LDI  R30,LOW(218)
	LDI  R31,HIGH(218)
	CALL SUBOPT_0x3C
; 0000 0909             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 090A             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x53
; 0000 090B             a[5] = 0x190;   //delta okrag
; 0000 090C             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x45
; 0000 090D             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 090E 
; 0000 090F             a[1] = a[0]+0x001;  //ster2
; 0000 0910             a[2] = a[4];        //ster4 ABS druciak
; 0000 0911             a[6] = a[5]+0x001;  //okrag
; 0000 0912             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0913 
; 0000 0914     break;
; 0000 0915 
; 0000 0916          case 36:
_0xD4:
	CPI  R30,LOW(0x24)
	LDI  R26,HIGH(0x24)
	CPC  R31,R26
	BRNE _0xD5
; 0000 0917 
; 0000 0918             a[0] = 0x0A2;   //ster1
	LDI  R30,LOW(162)
	LDI  R31,HIGH(162)
	CALL SUBOPT_0x3C
; 0000 0919             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x54
; 0000 091A             a[4] = 0x22;    //ster3 ABS krazek scierny
; 0000 091B             a[5] = 0x196;   //delta okrag
; 0000 091C             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3F
; 0000 091D             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x41
	RJMP _0x49C
; 0000 091E 
; 0000 091F             a[1] = a[0]+0x001;  //ster2
; 0000 0920             a[2] = a[4];        //ster4 ABS druciak
; 0000 0921             a[6] = a[5]+0x001;  //okrag
; 0000 0922             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0923 
; 0000 0924     break;
; 0000 0925 
; 0000 0926          case 37:
_0xD5:
	CPI  R30,LOW(0x25)
	LDI  R26,HIGH(0x25)
	CPC  R31,R26
	BRNE _0xD6
; 0000 0927 
; 0000 0928             a[0] = 0x104;   //ster1
	LDI  R30,LOW(260)
	LDI  R31,HIGH(260)
	CALL SUBOPT_0x3C
; 0000 0929             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 092A             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x51
; 0000 092B             a[5] = 0x19C;   //delta okrag
	CALL SUBOPT_0x55
; 0000 092C             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 092D             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 092E 
; 0000 092F             a[1] = a[0]+0x001;  //ster2
; 0000 0930             a[2] = a[4];        //ster4 ABS druciak
; 0000 0931             a[6] = a[5]+0x001;  //okrag
; 0000 0932             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0933 
; 0000 0934     break;
; 0000 0935 
; 0000 0936          case 38:
_0xD6:
	CPI  R30,LOW(0x26)
	LDI  R26,HIGH(0x26)
	CPC  R31,R26
	BRNE _0xD7
; 0000 0937 
; 0000 0938             a[0] = 0x036;   //ster1
	LDI  R30,LOW(54)
	LDI  R31,HIGH(54)
	CALL SUBOPT_0x3C
; 0000 0939             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 093A             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x51
; 0000 093B             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x49D
; 0000 093C             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 093D             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 093E 
; 0000 093F             a[1] = a[0]+0x001;  //ster2
; 0000 0940             a[2] = a[4];        //ster4 ABS druciak
; 0000 0941             a[6] = a[5]+0x001;  //okrag
; 0000 0942             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0943 
; 0000 0944     break;
; 0000 0945 
; 0000 0946 
; 0000 0947          case 39:
_0xD7:
	CPI  R30,LOW(0x27)
	LDI  R26,HIGH(0x27)
	CPC  R31,R26
	BRNE _0xD8
; 0000 0948 
; 0000 0949             a[0] = 0x118;   //ster1
	LDI  R30,LOW(280)
	LDI  R31,HIGH(280)
	CALL SUBOPT_0x3C
; 0000 094A             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 094B             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x53
; 0000 094C             a[5] = 0x190;   //delta okrag
; 0000 094D             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x49B
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
; 0000 0958          case 40:
_0xD8:
	CPI  R30,LOW(0x28)
	LDI  R26,HIGH(0x28)
	CPC  R31,R26
	BRNE _0xD9
; 0000 0959 
; 0000 095A             a[0] = 0x0A6;   //ster1
	LDI  R30,LOW(166)
	LDI  R31,HIGH(166)
	CALL SUBOPT_0x3C
; 0000 095B             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x54
; 0000 095C             a[4] = 0x22;    //ster3 ABS krazek scierny
; 0000 095D             a[5] = 0x196;   //delta okrag
; 0000 095E             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x49B
; 0000 095F             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0960 
; 0000 0961             a[1] = a[0]+0x001;  //ster2
; 0000 0962             a[2] = a[4];        //ster4 ABS druciak
; 0000 0963             a[6] = a[5]+0x001;  //okrag
; 0000 0964             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0965 
; 0000 0966     break;
; 0000 0967 
; 0000 0968          case 41:
_0xD9:
	CPI  R30,LOW(0x29)
	LDI  R26,HIGH(0x29)
	CPC  R31,R26
	BRNE _0xDA
; 0000 0969 
; 0000 096A             a[0] = 0x01E;   //ster1
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL SUBOPT_0x3C
; 0000 096B             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 096C             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x44
; 0000 096D             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x46
; 0000 096E             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x49B
; 0000 096F             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0970 
; 0000 0971             a[1] = a[0]+0x001;  //ster2
; 0000 0972             a[2] = a[4];        //ster4 ABS druciak
; 0000 0973             a[6] = a[5]+0x001;  //okrag
; 0000 0974             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0975 
; 0000 0976     break;
; 0000 0977 
; 0000 0978 
; 0000 0979          case 42:
_0xDA:
	CPI  R30,LOW(0x2A)
	LDI  R26,HIGH(0x2A)
	CPC  R31,R26
	BRNE _0xDB
; 0000 097A 
; 0000 097B             a[0] = 0x05C;   //ster1
	LDI  R30,LOW(92)
	LDI  R31,HIGH(92)
	CALL SUBOPT_0x3C
; 0000 097C             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3F
; 0000 097D             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x56
; 0000 097E             a[5] = 0x196;   //delta okrag
; 0000 097F             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x45
; 0000 0980             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0981 
; 0000 0982             a[1] = a[0]+0x001;  //ster2
; 0000 0983             a[2] = a[4];        //ster4 ABS druciak
; 0000 0984             a[6] = a[5]+0x001;  //okrag
; 0000 0985             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0986 
; 0000 0987     break;
; 0000 0988 
; 0000 0989 
; 0000 098A          case 43:
_0xDB:
	CPI  R30,LOW(0x2B)
	LDI  R26,HIGH(0x2B)
	CPC  R31,R26
	BRNE _0xDC
; 0000 098B 
; 0000 098C             a[0] = 0x062;   //ster1
	LDI  R30,LOW(98)
	LDI  R31,HIGH(98)
	CALL SUBOPT_0x3C
; 0000 098D             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 098E             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x50
; 0000 098F             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x52
; 0000 0990             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0991             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0992 
; 0000 0993             a[1] = a[0]+0x001;  //ster2
; 0000 0994             a[2] = a[4];        //ster4 ABS druciak
; 0000 0995             a[6] = a[5]+0x001;  //okrag
; 0000 0996             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0997 
; 0000 0998     break;
; 0000 0999 
; 0000 099A 
; 0000 099B          case 44:
_0xDC:
	CPI  R30,LOW(0x2C)
	LDI  R26,HIGH(0x2C)
	CPC  R31,R26
	BRNE _0xDD
; 0000 099C 
; 0000 099D             a[0] = 0x;   //ster1
	CALL SUBOPT_0x57
; 0000 099E             a[3] = 0x;    //ster4 INV druciak
; 0000 099F             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 09A0             a[5] = 0x;   //delta okrag
; 0000 09A1             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 09A2             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 09A3 
; 0000 09A4             a[1] = a[0]+0x001;  //ster2
; 0000 09A5             a[2] = a[4];        //ster4 ABS druciak
; 0000 09A6             a[6] = a[5]+0x001;  //okrag
; 0000 09A7             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09A8 
; 0000 09A9     break;
; 0000 09AA 
; 0000 09AB 
; 0000 09AC          case 45:
_0xDD:
	CPI  R30,LOW(0x2D)
	LDI  R26,HIGH(0x2D)
	CPC  R31,R26
	BRNE _0xDE
; 0000 09AD 
; 0000 09AE             a[0] = 0x010;   //ster1
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL SUBOPT_0x3C
; 0000 09AF             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 09B0             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x44
; 0000 09B1             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x46
; 0000 09B2             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x45
; 0000 09B3             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 09B4 
; 0000 09B5             a[1] = a[0]+0x001;  //ster2
; 0000 09B6             a[2] = a[4];        //ster4 ABS druciak
; 0000 09B7             a[6] = a[5]+0x001;  //okrag
; 0000 09B8             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09B9 
; 0000 09BA     break;
; 0000 09BB 
; 0000 09BC 
; 0000 09BD     case 46:
_0xDE:
	CPI  R30,LOW(0x2E)
	LDI  R26,HIGH(0x2E)
	CPC  R31,R26
	BRNE _0xDF
; 0000 09BE 
; 0000 09BF             a[0] = 0x050;   //ster1
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	CALL SUBOPT_0x3C
; 0000 09C0             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3F
; 0000 09C1             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x56
; 0000 09C2             a[5] = 0x196;   //delta okrag
; 0000 09C3             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x49B
; 0000 09C4             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 09C5 
; 0000 09C6             a[1] = a[0]+0x001;  //ster2
; 0000 09C7             a[2] = a[4];        //ster4 ABS druciak
; 0000 09C8             a[6] = a[5]+0x001;  //okrag
; 0000 09C9             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09CA 
; 0000 09CB     break;
; 0000 09CC 
; 0000 09CD 
; 0000 09CE     case 47:
_0xDF:
	CPI  R30,LOW(0x2F)
	LDI  R26,HIGH(0x2F)
	CPC  R31,R26
	BRNE _0xE0
; 0000 09CF 
; 0000 09D0             a[0] = 0x068;   //ster1
	LDI  R30,LOW(104)
	LDI  R31,HIGH(104)
	CALL SUBOPT_0x3C
; 0000 09D1             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 09D2             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x50
; 0000 09D3             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x49D
; 0000 09D4             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 09D5             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 09D6 
; 0000 09D7             a[1] = a[0]+0x001;  //ster2
; 0000 09D8             a[2] = a[4];        //ster4 ABS druciak
; 0000 09D9             a[6] = a[5]+0x001;  //okrag
; 0000 09DA             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09DB 
; 0000 09DC     break;
; 0000 09DD 
; 0000 09DE 
; 0000 09DF 
; 0000 09E0     case 48:
_0xE0:
	CPI  R30,LOW(0x30)
	LDI  R26,HIGH(0x30)
	CPC  R31,R26
	BRNE _0xE1
; 0000 09E1 
; 0000 09E2             a[0] = 0x;   //ster1
	CALL SUBOPT_0x57
; 0000 09E3             a[3] = 0x;    //ster4 INV druciak
; 0000 09E4             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 09E5             a[5] = 0x;   //delta okrag
; 0000 09E6             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 09E7             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 09E8 
; 0000 09E9             a[1] = a[0]+0x001;  //ster2
; 0000 09EA             a[2] = a[4];        //ster4 ABS druciak
; 0000 09EB             a[6] = a[5]+0x001;  //okrag
; 0000 09EC             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09ED 
; 0000 09EE     break;
; 0000 09EF 
; 0000 09F0 
; 0000 09F1     case 49:
_0xE1:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0xE2
; 0000 09F2 
; 0000 09F3             a[0] = 0x024;   //ster1
	LDI  R30,LOW(36)
	LDI  R31,HIGH(36)
	CALL SUBOPT_0x3C
; 0000 09F4             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 09F5             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x44
; 0000 09F6             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x43
; 0000 09F7             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 09F8             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 09F9 
; 0000 09FA             a[1] = a[0]+0x001;  //ster2
; 0000 09FB             a[2] = a[4];        //ster4 ABS druciak
; 0000 09FC             a[6] = a[5]+0x001;  //okrag
; 0000 09FD             a[8] = a[6]+0x001;  //-delta okrag
; 0000 09FE 
; 0000 09FF     break;
; 0000 0A00 
; 0000 0A01 
; 0000 0A02     case 50:
_0xE2:
	CPI  R30,LOW(0x32)
	LDI  R26,HIGH(0x32)
	CPC  R31,R26
	BRNE _0xE3
; 0000 0A03 
; 0000 0A04             a[0] = 0x014;   //ster1
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0x3C
; 0000 0A05             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0A06             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x53
; 0000 0A07             a[5] = 0x190;   //delta okrag
; 0000 0A08             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x45
; 0000 0A09             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0A0A 
; 0000 0A0B             a[1] = a[0]+0x001;  //ster2
; 0000 0A0C             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A0D             a[6] = a[5]+0x001;  //okrag
; 0000 0A0E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A0F 
; 0000 0A10     break;
; 0000 0A11 
; 0000 0A12     case 51:
_0xE3:
	CPI  R30,LOW(0x33)
	LDI  R26,HIGH(0x33)
	CPC  R31,R26
	BRNE _0xE4
; 0000 0A13 
; 0000 0A14             a[0] = 0x082;   //ster1
	LDI  R30,LOW(130)
	LDI  R31,HIGH(130)
	CALL SUBOPT_0x3C
; 0000 0A15             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0A16             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x58
; 0000 0A17             a[5] = 0x19C;   //delta okrag
	CALL SUBOPT_0x55
; 0000 0A18             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0A19             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0A1A 
; 0000 0A1B             a[1] = a[0]+0x001;  //ster2
; 0000 0A1C             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A1D             a[6] = a[5]+0x001;  //okrag
; 0000 0A1E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A1F 
; 0000 0A20     break;
; 0000 0A21 
; 0000 0A22     case 52:
_0xE4:
	CPI  R30,LOW(0x34)
	LDI  R26,HIGH(0x34)
	CPC  R31,R26
	BRNE _0xE5
; 0000 0A23 
; 0000 0A24             a[0] = 0x106;   //ster1
	LDI  R30,LOW(262)
	LDI  R31,HIGH(262)
	CALL SUBOPT_0x3C
; 0000 0A25             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0A26             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x59
; 0000 0A27             a[5] = 0x190;   //delta okrag
; 0000 0A28             a[7] = 0x13;    //ster3 INV krazek scierny
	RJMP _0x49B
; 0000 0A29             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0A2A 
; 0000 0A2B             a[1] = a[0]+0x001;  //ster2
; 0000 0A2C             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A2D             a[6] = a[5]+0x001;  //okrag
; 0000 0A2E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A2F 
; 0000 0A30     break;
; 0000 0A31 
; 0000 0A32 
; 0000 0A33     case 53:
_0xE5:
	CPI  R30,LOW(0x35)
	LDI  R26,HIGH(0x35)
	CPC  R31,R26
	BRNE _0xE6
; 0000 0A34 
; 0000 0A35             a[0] = 0x04C;   //ster1
	LDI  R30,LOW(76)
	LDI  R31,HIGH(76)
	CALL SUBOPT_0x3C
; 0000 0A36             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0A37             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x44
; 0000 0A38             a[5] = 0x196;   //delta okrag
	RJMP _0x49D
; 0000 0A39             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0A3A             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0A3B 
; 0000 0A3C             a[1] = a[0]+0x001;  //ster2
; 0000 0A3D             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A3E             a[6] = a[5]+0x001;  //okrag
; 0000 0A3F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A40 
; 0000 0A41     break;
; 0000 0A42 
; 0000 0A43 
; 0000 0A44     case 54:
_0xE6:
	CPI  R30,LOW(0x36)
	LDI  R26,HIGH(0x36)
	CPC  R31,R26
	BRNE _0xE7
; 0000 0A45 
; 0000 0A46             a[0] = 0x01C;   //ster1
	LDI  R30,LOW(28)
	LDI  R31,HIGH(28)
	CALL SUBOPT_0x3C
; 0000 0A47             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0A48             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x53
; 0000 0A49             a[5] = 0x190;   //delta okrag
; 0000 0A4A             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x49B
; 0000 0A4B             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0A4C 
; 0000 0A4D             a[1] = a[0]+0x001;  //ster2
; 0000 0A4E             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A4F             a[6] = a[5]+0x001;  //okrag
; 0000 0A50             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A51 
; 0000 0A52     break;
; 0000 0A53 
; 0000 0A54     case 55:
_0xE7:
	CPI  R30,LOW(0x37)
	LDI  R26,HIGH(0x37)
	CPC  R31,R26
	BRNE _0xE8
; 0000 0A55 
; 0000 0A56             a[0] = 0x114;   //ster1
	LDI  R30,LOW(276)
	LDI  R31,HIGH(276)
	CALL SUBOPT_0x3C
; 0000 0A57             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0A58             a[4] = 0x1A;    //ster3 ABS krazek scierny
	LDI  R26,LOW(26)
	LDI  R27,HIGH(26)
	RJMP _0x49E
; 0000 0A59             a[5] = 0x19C;   //delta okrag
; 0000 0A5A             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0A5B             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0A5C 
; 0000 0A5D             a[1] = a[0]+0x001;  //ster2
; 0000 0A5E             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A5F             a[6] = a[5]+0x001;  //okrag
; 0000 0A60             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A61 
; 0000 0A62     break;
; 0000 0A63 
; 0000 0A64 
; 0000 0A65     case 56:
_0xE8:
	CPI  R30,LOW(0x38)
	LDI  R26,HIGH(0x38)
	CPC  R31,R26
	BRNE _0xE9
; 0000 0A66 
; 0000 0A67             a[0] = 0x0EE;   //ster1
	LDI  R30,LOW(238)
	LDI  R31,HIGH(238)
	CALL SUBOPT_0x3C
; 0000 0A68             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0A69             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x59
; 0000 0A6A             a[5] = 0x190;   //delta okrag
; 0000 0A6B             a[7] = 0x13;    //ster3 INV krazek scierny
	CALL SUBOPT_0x45
; 0000 0A6C             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0A6D 
; 0000 0A6E             a[1] = a[0]+0x001;  //ster2
; 0000 0A6F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A70             a[6] = a[5]+0x001;  //okrag
; 0000 0A71             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A72 
; 0000 0A73     break;
; 0000 0A74 
; 0000 0A75 
; 0000 0A76     case 57:
_0xE9:
	CPI  R30,LOW(0x39)
	LDI  R26,HIGH(0x39)
	CPC  R31,R26
	BRNE _0xEA
; 0000 0A77 
; 0000 0A78             a[0] = 0x0F8;   //ster1
	LDI  R30,LOW(248)
	LDI  R31,HIGH(248)
	CALL SUBOPT_0x3C
; 0000 0A79             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0A7A             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5A
; 0000 0A7B             a[5] = 0x190;   //delta okrag
; 0000 0A7C             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x45
; 0000 0A7D             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0A7E 
; 0000 0A7F             a[1] = a[0]+0x001;  //ster2
; 0000 0A80             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A81             a[6] = a[5]+0x001;  //okrag
; 0000 0A82             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A83 
; 0000 0A84     break;
; 0000 0A85 
; 0000 0A86 
; 0000 0A87     case 58:
_0xEA:
	CPI  R30,LOW(0x3A)
	LDI  R26,HIGH(0x3A)
	CPC  R31,R26
	BRNE _0xEB
; 0000 0A88 
; 0000 0A89             a[0] = 0x0E4;   //ster1
	LDI  R30,LOW(228)
	LDI  R31,HIGH(228)
	CALL SUBOPT_0x3C
; 0000 0A8A             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0A8B             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x50
; 0000 0A8C             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x52
; 0000 0A8D             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0A8E             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0A8F 
; 0000 0A90             a[1] = a[0]+0x001;  //ster2
; 0000 0A91             a[2] = a[4];        //ster4 ABS druciak
; 0000 0A92             a[6] = a[5]+0x001;  //okrag
; 0000 0A93             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0A94 
; 0000 0A95     break;
; 0000 0A96 
; 0000 0A97 
; 0000 0A98     case 59:
_0xEB:
	CPI  R30,LOW(0x3B)
	LDI  R26,HIGH(0x3B)
	CPC  R31,R26
	BRNE _0xEC
; 0000 0A99 
; 0000 0A9A             a[0] = 0x052;   //ster1
	LDI  R30,LOW(82)
	LDI  R31,HIGH(82)
	CALL SUBOPT_0x3C
; 0000 0A9B             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0A9C             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5B
; 0000 0A9D             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x4D
; 0000 0A9E             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0A9F             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0AA0 
; 0000 0AA1             a[1] = a[0]+0x001;  //ster2
; 0000 0AA2             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AA3             a[6] = a[5]+0x001;  //okrag
; 0000 0AA4             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0AA5 
; 0000 0AA6     break;
; 0000 0AA7 
; 0000 0AA8 
; 0000 0AA9     case 60:
_0xEC:
	CPI  R30,LOW(0x3C)
	LDI  R26,HIGH(0x3C)
	CPC  R31,R26
	BRNE _0xED
; 0000 0AAA 
; 0000 0AAB             a[0] = 0x090;   //ster1
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	CALL SUBOPT_0x3C
; 0000 0AAC             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0AAD             a[4] = 0x1A;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5C
; 0000 0AAE             a[5] = 0x190;   //delta okrag
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	CALL SUBOPT_0x46
; 0000 0AAF             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x45
; 0000 0AB0             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0AB1 
; 0000 0AB2             a[1] = a[0]+0x001;  //ster2
; 0000 0AB3             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AB4             a[6] = a[5]+0x001;  //okrag
; 0000 0AB5             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0AB6 
; 0000 0AB7     break;
; 0000 0AB8 
; 0000 0AB9 
; 0000 0ABA     case 61:
_0xED:
	CPI  R30,LOW(0x3D)
	LDI  R26,HIGH(0x3D)
	CPC  R31,R26
	BRNE _0xEE
; 0000 0ABB 
; 0000 0ABC             a[0] = 0x0FC;   //ster1
	LDI  R30,LOW(252)
	LDI  R31,HIGH(252)
	CALL SUBOPT_0x3C
; 0000 0ABD             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0ABE             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4F
; 0000 0ABF             a[5] = 0x190;   //delta okrag
; 0000 0AC0             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x49B
; 0000 0AC1             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0AC2 
; 0000 0AC3             a[1] = a[0]+0x001;  //ster2
; 0000 0AC4             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AC5             a[6] = a[5]+0x001;  //okrag
; 0000 0AC6             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0AC7 
; 0000 0AC8     break;
; 0000 0AC9 
; 0000 0ACA 
; 0000 0ACB     case 62:
_0xEE:
	CPI  R30,LOW(0x3E)
	LDI  R26,HIGH(0x3E)
	CPC  R31,R26
	BRNE _0xEF
; 0000 0ACC 
; 0000 0ACD             a[0] = 0x028;   //ster1
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	CALL SUBOPT_0x3C
; 0000 0ACE             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0ACF             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x50
; 0000 0AD0             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x49D
; 0000 0AD1             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0AD2             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0AD3 
; 0000 0AD4             a[1] = a[0]+0x001;  //ster2
; 0000 0AD5             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AD6             a[6] = a[5]+0x001;  //okrag
; 0000 0AD7             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0AD8 
; 0000 0AD9     break;
; 0000 0ADA 
; 0000 0ADB 
; 0000 0ADC     case 63:
_0xEF:
	CPI  R30,LOW(0x3F)
	LDI  R26,HIGH(0x3F)
	CPC  R31,R26
	BRNE _0xF0
; 0000 0ADD 
; 0000 0ADE             a[0] = 0x034;   //ster1
	LDI  R30,LOW(52)
	LDI  R31,HIGH(52)
	CALL SUBOPT_0x3C
; 0000 0ADF             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0AE0             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5B
; 0000 0AE1             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x49D
; 0000 0AE2             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0AE3             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0AE4 
; 0000 0AE5             a[1] = a[0]+0x001;  //ster2
; 0000 0AE6             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AE7             a[6] = a[5]+0x001;  //okrag
; 0000 0AE8             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0AE9 
; 0000 0AEA     break;
; 0000 0AEB 
; 0000 0AEC 
; 0000 0AED     case 64:
_0xF0:
	CPI  R30,LOW(0x40)
	LDI  R26,HIGH(0x40)
	CPC  R31,R26
	BRNE _0xF1
; 0000 0AEE 
; 0000 0AEF             a[0] = 0x0EC;   //ster1
	LDI  R30,LOW(236)
	LDI  R31,HIGH(236)
	CALL SUBOPT_0x3C
; 0000 0AF0             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0AF1             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5A
; 0000 0AF2             a[5] = 0x190;   //delta okrag
; 0000 0AF3             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x49B
; 0000 0AF4             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0AF5 
; 0000 0AF6             a[1] = a[0]+0x001;  //ster2
; 0000 0AF7             a[2] = a[4];        //ster4 ABS druciak
; 0000 0AF8             a[6] = a[5]+0x001;  //okrag
; 0000 0AF9             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0AFA 
; 0000 0AFB     break;
; 0000 0AFC 
; 0000 0AFD 
; 0000 0AFE     case 65:
_0xF1:
	CPI  R30,LOW(0x41)
	LDI  R26,HIGH(0x41)
	CPC  R31,R26
	BRNE _0xF2
; 0000 0AFF 
; 0000 0B00             a[0] = 0x0CC;   //ster1
	LDI  R30,LOW(204)
	LDI  R31,HIGH(204)
	CALL SUBOPT_0x3C
; 0000 0B01             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0B02             a[4] = 0x16;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5D
; 0000 0B03             a[5] = 0x193;   //delta okrag
	CALL SUBOPT_0x43
; 0000 0B04             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B05             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0B06 
; 0000 0B07             a[1] = a[0]+0x001;  //ster2
; 0000 0B08             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B09             a[6] = a[5]+0x001;  //okrag
; 0000 0B0A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B0B 
; 0000 0B0C     break;
; 0000 0B0D 
; 0000 0B0E 
; 0000 0B0F     case 66:
_0xF2:
	CPI  R30,LOW(0x42)
	LDI  R26,HIGH(0x42)
	CPC  R31,R26
	BRNE _0xF3
; 0000 0B10 
; 0000 0B11             a[0] = 0x0BC;   //ster1
	LDI  R30,LOW(188)
	LDI  R31,HIGH(188)
	CALL SUBOPT_0x3C
; 0000 0B12             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0B13             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5B
; 0000 0B14             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5E
; 0000 0B15             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x49B
; 0000 0B16             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B17 
; 0000 0B18             a[1] = a[0]+0x001;  //ster2
; 0000 0B19             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B1A             a[6] = a[5]+0x001;  //okrag
; 0000 0B1B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B1C 
; 0000 0B1D     break;
; 0000 0B1E 
; 0000 0B1F 
; 0000 0B20     case 67:
_0xF3:
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BRNE _0xF4
; 0000 0B21 
; 0000 0B22             a[0] = 0x09C;   //ster1
	LDI  R30,LOW(156)
	LDI  R31,HIGH(156)
	CALL SUBOPT_0x3C
; 0000 0B23             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0B24             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5B
; 0000 0B25             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x49D
; 0000 0B26             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B27             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B28 
; 0000 0B29             a[1] = a[0]+0x001;  //ster2
; 0000 0B2A             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B2B             a[6] = a[5]+0x001;  //okrag
; 0000 0B2C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B2D 
; 0000 0B2E     break;
; 0000 0B2F 
; 0000 0B30 
; 0000 0B31     case 68:
_0xF4:
	CPI  R30,LOW(0x44)
	LDI  R26,HIGH(0x44)
	CPC  R31,R26
	BRNE _0xF5
; 0000 0B32 
; 0000 0B33             a[0] = 0x07C;   //ster1
	LDI  R30,LOW(124)
	LDI  R31,HIGH(124)
	CALL SUBOPT_0x3C
; 0000 0B34             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0B35             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x49
; 0000 0B36             a[5] = 0x199;   //delta okrag
	RJMP _0x49D
; 0000 0B37             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B38             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B39 
; 0000 0B3A             a[1] = a[0]+0x001;  //ster2
; 0000 0B3B             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B3C             a[6] = a[5]+0x001;  //okrag
; 0000 0B3D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B3E 
; 0000 0B3F     break;
; 0000 0B40 
; 0000 0B41 
; 0000 0B42     case 69:
_0xF5:
	CPI  R30,LOW(0x45)
	LDI  R26,HIGH(0x45)
	CPC  R31,R26
	BRNE _0xF6
; 0000 0B43 
; 0000 0B44             a[0] = 0x0D2;   //ster1
	LDI  R30,LOW(210)
	LDI  R31,HIGH(210)
	CALL SUBOPT_0x3C
; 0000 0B45             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0B46             a[4] = 0x16;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5D
; 0000 0B47             a[5] = 0x193;   //delta okrag
	RJMP _0x49D
; 0000 0B48             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B49             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0B4A 
; 0000 0B4B             a[1] = a[0]+0x001;  //ster2
; 0000 0B4C             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B4D             a[6] = a[5]+0x001;  //okrag
; 0000 0B4E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B4F 
; 0000 0B50     break;
; 0000 0B51 
; 0000 0B52 
; 0000 0B53     case 70:
_0xF6:
	CPI  R30,LOW(0x46)
	LDI  R26,HIGH(0x46)
	CPC  R31,R26
	BRNE _0xF7
; 0000 0B54 
; 0000 0B55             a[0] = 0x0E6;   //ster1
	LDI  R30,LOW(230)
	LDI  R31,HIGH(230)
	CALL SUBOPT_0x3C
; 0000 0B56             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0B57             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5B
; 0000 0B58             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5E
; 0000 0B59             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x45
; 0000 0B5A             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0B5B 
; 0000 0B5C             a[1] = a[0]+0x001;  //ster2
; 0000 0B5D             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B5E             a[6] = a[5]+0x001;  //okrag
; 0000 0B5F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B60 
; 0000 0B61     break;
; 0000 0B62 
; 0000 0B63 
; 0000 0B64     case 71:
_0xF7:
	CPI  R30,LOW(0x47)
	LDI  R26,HIGH(0x47)
	CPC  R31,R26
	BRNE _0xF8
; 0000 0B65 
; 0000 0B66             a[0] = 0x0B4;   //ster1
	LDI  R30,LOW(180)
	LDI  R31,HIGH(180)
	CALL SUBOPT_0x3C
; 0000 0B67             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0B68             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5B
; 0000 0B69             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x52
; 0000 0B6A             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B6B             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0B6C 
; 0000 0B6D             a[1] = a[0]+0x001;  //ster2
; 0000 0B6E             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B6F             a[6] = a[5]+0x001;  //okrag
; 0000 0B70             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B71 
; 0000 0B72     break;
; 0000 0B73 
; 0000 0B74 
; 0000 0B75     case 72:
_0xF8:
	CPI  R30,LOW(0x48)
	LDI  R26,HIGH(0x48)
	CPC  R31,R26
	BRNE _0xF9
; 0000 0B76 
; 0000 0B77             a[0] = 0x0AC;   //ster1
	LDI  R30,LOW(172)
	LDI  R31,HIGH(172)
	CALL SUBOPT_0x3C
; 0000 0B78             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0B79             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x49
; 0000 0B7A             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x43
; 0000 0B7B             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B7C             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0B7D 
; 0000 0B7E             a[1] = a[0]+0x001;  //ster2
; 0000 0B7F             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B80             a[6] = a[5]+0x001;  //okrag
; 0000 0B81             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B82 
; 0000 0B83     break;
; 0000 0B84 
; 0000 0B85 
; 0000 0B86     case 73:
_0xF9:
	CPI  R30,LOW(0x49)
	LDI  R26,HIGH(0x49)
	CPC  R31,R26
	BRNE _0xFA
; 0000 0B87 
; 0000 0B88             a[0] = 0x012;   //ster1
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	CALL SUBOPT_0x3C
; 0000 0B89             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3F
; 0000 0B8A             a[4] = 0x1B;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x58
; 0000 0B8B             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x52
; 0000 0B8C             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B8D             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0B8E 
; 0000 0B8F             a[1] = a[0]+0x001;  //ster2
; 0000 0B90             a[2] = a[4];        //ster4 ABS druciak
; 0000 0B91             a[6] = a[5]+0x001;  //okrag
; 0000 0B92             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0B93 
; 0000 0B94     break;
; 0000 0B95 
; 0000 0B96 
; 0000 0B97     case 74:
_0xFA:
	CPI  R30,LOW(0x4A)
	LDI  R26,HIGH(0x4A)
	CPC  R31,R26
	BRNE _0xFB
; 0000 0B98 
; 0000 0B99             a[0] = 0x0B2;   //ster1
	LDI  R30,LOW(178)
	LDI  R31,HIGH(178)
	CALL SUBOPT_0x3C
; 0000 0B9A             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0B9B             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x44
; 0000 0B9C             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x43
; 0000 0B9D             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0B9E             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0B9F 
; 0000 0BA0             a[1] = a[0]+0x001;  //ster2
; 0000 0BA1             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BA2             a[6] = a[5]+0x001;  //okrag
; 0000 0BA3             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BA4 
; 0000 0BA5     break;
; 0000 0BA6 
; 0000 0BA7 
; 0000 0BA8     case 75:
_0xFB:
	CPI  R30,LOW(0x4B)
	LDI  R26,HIGH(0x4B)
	CPC  R31,R26
	BRNE _0xFC
; 0000 0BA9 
; 0000 0BAA             a[0] = 0x10C;   //ster1
	LDI  R30,LOW(268)
	LDI  R31,HIGH(268)
	CALL SUBOPT_0x3C
; 0000 0BAB             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0BAC             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x51
; 0000 0BAD             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x52
; 0000 0BAE             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0BAF             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0BB0 
; 0000 0BB1             a[1] = a[0]+0x001;  //ster2
; 0000 0BB2             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BB3             a[6] = a[5]+0x001;  //okrag
; 0000 0BB4             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BB5 
; 0000 0BB6     break;
; 0000 0BB7 
; 0000 0BB8 
; 0000 0BB9     case 76:
_0xFC:
	CPI  R30,LOW(0x4C)
	LDI  R26,HIGH(0x4C)
	CPC  R31,R26
	BRNE _0xFD
; 0000 0BBA 
; 0000 0BBB             a[0] = 0x;   //ster1
	CALL SUBOPT_0x57
; 0000 0BBC             a[3] = 0x;    //ster4 INV druciak
; 0000 0BBD             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0BBE             a[5] = 0x;   //delta okrag
; 0000 0BBF             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0BC0             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0BC1 
; 0000 0BC2             a[1] = a[0]+0x001;  //ster2
; 0000 0BC3             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BC4             a[6] = a[5]+0x001;  //okrag
; 0000 0BC5             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BC6 
; 0000 0BC7     break;
; 0000 0BC8 
; 0000 0BC9 
; 0000 0BCA     case 77:
_0xFD:
	CPI  R30,LOW(0x4D)
	LDI  R26,HIGH(0x4D)
	CPC  R31,R26
	BRNE _0xFE
; 0000 0BCB 
; 0000 0BCC             a[0] = 0x026;   //ster1
	LDI  R30,LOW(38)
	LDI  R31,HIGH(38)
	CALL SUBOPT_0x3C
; 0000 0BCD             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3F
; 0000 0BCE             a[4] = 0x1B;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x58
; 0000 0BCF             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x49D
; 0000 0BD0             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0BD1             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0BD2 
; 0000 0BD3             a[1] = a[0]+0x001;  //ster2
; 0000 0BD4             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BD5             a[6] = a[5]+0x001;  //okrag
; 0000 0BD6             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BD7 
; 0000 0BD8     break;
; 0000 0BD9 
; 0000 0BDA 
; 0000 0BDB     case 78:
_0xFE:
	CPI  R30,LOW(0x4E)
	LDI  R26,HIGH(0x4E)
	CPC  R31,R26
	BRNE _0xFF
; 0000 0BDC 
; 0000 0BDD             a[0] = 0x11C;   //ster1
	LDI  R30,LOW(284)
	LDI  R31,HIGH(284)
	CALL SUBOPT_0x3C
; 0000 0BDE             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0BDF             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5F
; 0000 0BE0             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x49D
; 0000 0BE1             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0BE2             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0BE3 
; 0000 0BE4             a[1] = a[0]+0x001;  //ster2
; 0000 0BE5             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BE6             a[6] = a[5]+0x001;  //okrag
; 0000 0BE7             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BE8 
; 0000 0BE9     break;
; 0000 0BEA 
; 0000 0BEB 
; 0000 0BEC     case 79:
_0xFF:
	CPI  R30,LOW(0x4F)
	LDI  R26,HIGH(0x4F)
	CPC  R31,R26
	BRNE _0x100
; 0000 0BED 
; 0000 0BEE             a[0] = 0x112;   //ster1
	LDI  R30,LOW(274)
	LDI  R31,HIGH(274)
	CALL SUBOPT_0x3C
; 0000 0BEF             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0BF0             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x51
; 0000 0BF1             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x49D
; 0000 0BF2             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0BF3             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0BF4 
; 0000 0BF5             a[1] = a[0]+0x001;  //ster2
; 0000 0BF6             a[2] = a[4];        //ster4 ABS druciak
; 0000 0BF7             a[6] = a[5]+0x001;  //okrag
; 0000 0BF8             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0BF9 
; 0000 0BFA     break;
; 0000 0BFB 
; 0000 0BFC     case 80:
_0x100:
	CPI  R30,LOW(0x50)
	LDI  R26,HIGH(0x50)
	CPC  R31,R26
	BRNE _0x101
; 0000 0BFD 
; 0000 0BFE             a[0] = 0x;   //ster1
	CALL SUBOPT_0x57
; 0000 0BFF             a[3] = 0x;    //ster4 INV druciak
; 0000 0C00             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0C01             a[5] = 0x;   //delta okrag
; 0000 0C02             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0C03             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0C04 
; 0000 0C05             a[1] = a[0]+0x001;  //ster2
; 0000 0C06             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C07             a[6] = a[5]+0x001;  //okrag
; 0000 0C08             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C09 
; 0000 0C0A     break;
; 0000 0C0B 
; 0000 0C0C     case 81:
_0x101:
	CPI  R30,LOW(0x51)
	LDI  R26,HIGH(0x51)
	CPC  R31,R26
	BRNE _0x102
; 0000 0C0D 
; 0000 0C0E             a[0] = 0x0EA;   //ster1
	LDI  R30,LOW(234)
	LDI  R31,HIGH(234)
	CALL SUBOPT_0x3C
; 0000 0C0F             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0C10             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x60
; 0000 0C11             a[5] = 0x193;   //delta okrag
	CALL SUBOPT_0x43
; 0000 0C12             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C13             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0C14 
; 0000 0C15             a[1] = a[0]+0x001;  //ster2
; 0000 0C16             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C17             a[6] = a[5]+0x001;  //okrag
; 0000 0C18             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C19 
; 0000 0C1A     break;
; 0000 0C1B 
; 0000 0C1C 
; 0000 0C1D     case 82:
_0x102:
	CPI  R30,LOW(0x52)
	LDI  R26,HIGH(0x52)
	CPC  R31,R26
	BRNE _0x103
; 0000 0C1E 
; 0000 0C1F             a[0] = 0x0D8;   //ster1
	LDI  R30,LOW(216)
	LDI  R31,HIGH(216)
	CALL SUBOPT_0x3C
; 0000 0C20             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0C21             a[4] = 0x14;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x61
; 0000 0C22             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x43
; 0000 0C23             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C24             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0C25 
; 0000 0C26             a[1] = a[0]+0x001;  //ster2
; 0000 0C27             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C28             a[6] = a[5]+0x001;  //okrag
; 0000 0C29             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C2A 
; 0000 0C2B     break;
; 0000 0C2C 
; 0000 0C2D 
; 0000 0C2E     case 83:
_0x103:
	CPI  R30,LOW(0x53)
	LDI  R26,HIGH(0x53)
	CPC  R31,R26
	BRNE _0x104
; 0000 0C2F 
; 0000 0C30             a[0] = 0x08C;   //ster1
	LDI  R30,LOW(140)
	LDI  R31,HIGH(140)
	CALL SUBOPT_0x3C
; 0000 0C31             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0C32             a[4] = 0x22;    //ster3 ABS krazek scierny
	LDI  R26,LOW(34)
	LDI  R27,HIGH(34)
	CALL SUBOPT_0x62
; 0000 0C33             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x49D
; 0000 0C34             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C35             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0C36 
; 0000 0C37             a[1] = a[0]+0x001;  //ster2
; 0000 0C38             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C39             a[6] = a[5]+0x001;  //okrag
; 0000 0C3A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C3B 
; 0000 0C3C     break;
; 0000 0C3D 
; 0000 0C3E 
; 0000 0C3F     case 84:
_0x104:
	CPI  R30,LOW(0x54)
	LDI  R26,HIGH(0x54)
	CPC  R31,R26
	BRNE _0x105
; 0000 0C40 
; 0000 0C41             a[0] = 0x0A0;   //ster1
	LDI  R30,LOW(160)
	LDI  R31,HIGH(160)
	CALL SUBOPT_0x3C
; 0000 0C42             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x63
; 0000 0C43             a[4] = 0x24;    //ster3 ABS krazek scierny
; 0000 0C44             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x64
; 0000 0C45             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x49B
; 0000 0C46             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0C47 
; 0000 0C48             a[1] = a[0]+0x001;  //ster2
; 0000 0C49             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C4A             a[6] = a[5]+0x001;  //okrag
; 0000 0C4B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C4C 
; 0000 0C4D     break;
; 0000 0C4E 
; 0000 0C4F 
; 0000 0C50    case 85:
_0x105:
	CPI  R30,LOW(0x55)
	LDI  R26,HIGH(0x55)
	CPC  R31,R26
	BRNE _0x106
; 0000 0C51 
; 0000 0C52             a[0] = 0x0AE;   //ster1
	LDI  R30,LOW(174)
	LDI  R31,HIGH(174)
	CALL SUBOPT_0x3C
; 0000 0C53             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0C54             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x60
; 0000 0C55             a[5] = 0x193;   //delta okrag
	RJMP _0x49D
; 0000 0C56             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C57             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0C58 
; 0000 0C59             a[1] = a[0]+0x001;  //ster2
; 0000 0C5A             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C5B             a[6] = a[5]+0x001;  //okrag
; 0000 0C5C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C5D 
; 0000 0C5E     break;
; 0000 0C5F 
; 0000 0C60     case 86:
_0x106:
	CPI  R30,LOW(0x56)
	LDI  R26,HIGH(0x56)
	CPC  R31,R26
	BRNE _0x107
; 0000 0C61 
; 0000 0C62             a[0] = 0x0F6;   //ster1
	LDI  R30,LOW(246)
	LDI  R31,HIGH(246)
	CALL SUBOPT_0x3C
; 0000 0C63             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0C64             a[4] = 0x14;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x61
; 0000 0C65             a[5] = 0x190;   //delta okrag
	RJMP _0x49D
; 0000 0C66             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C67             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0C68 
; 0000 0C69             a[1] = a[0]+0x001;  //ster2
; 0000 0C6A             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C6B             a[6] = a[5]+0x001;  //okrag
; 0000 0C6C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C6D 
; 0000 0C6E     break;
; 0000 0C6F 
; 0000 0C70 
; 0000 0C71     case 87:
_0x107:
	CPI  R30,LOW(0x57)
	LDI  R26,HIGH(0x57)
	CPC  R31,R26
	BRNE _0x108
; 0000 0C72 
; 0000 0C73             a[0] = 0x0C4;   //ster1
	LDI  R30,LOW(196)
	LDI  R31,HIGH(196)
	CALL SUBOPT_0x3C
; 0000 0C74             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0C75             a[4] = 0x23;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x65
; 0000 0C76             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x4D
; 0000 0C77             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C78             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0C79 
; 0000 0C7A             a[1] = a[0]+0x001;  //ster2
; 0000 0C7B             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C7C             a[6] = a[5]+0x001;  //okrag
; 0000 0C7D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C7E 
; 0000 0C7F     break;
; 0000 0C80 
; 0000 0C81 
; 0000 0C82     case 88:
_0x108:
	CPI  R30,LOW(0x58)
	LDI  R26,HIGH(0x58)
	CPC  R31,R26
	BRNE _0x109
; 0000 0C83 
; 0000 0C84             a[0] = 0x07E;   //ster1
	LDI  R30,LOW(126)
	LDI  R31,HIGH(126)
	CALL SUBOPT_0x3C
; 0000 0C85             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x63
; 0000 0C86             a[4] = 0x24;    //ster3 ABS krazek scierny
; 0000 0C87             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x64
; 0000 0C88             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3F
; 0000 0C89             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x41
	RJMP _0x49C
; 0000 0C8A 
; 0000 0C8B             a[1] = a[0]+0x001;  //ster2
; 0000 0C8C             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C8D             a[6] = a[5]+0x001;  //okrag
; 0000 0C8E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0C8F 
; 0000 0C90     break;
; 0000 0C91 
; 0000 0C92 
; 0000 0C93     case 89:
_0x109:
	CPI  R30,LOW(0x59)
	LDI  R26,HIGH(0x59)
	CPC  R31,R26
	BRNE _0x10A
; 0000 0C94 
; 0000 0C95             a[0] = 0x02C;   //ster1
	LDI  R30,LOW(44)
	LDI  R31,HIGH(44)
	CALL SUBOPT_0x3C
; 0000 0C96             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0C97             a[4] = 0x1A;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5C
; 0000 0C98             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x52
; 0000 0C99             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0C9A             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0C9B 
; 0000 0C9C             a[1] = a[0]+0x001;  //ster2
; 0000 0C9D             a[2] = a[4];        //ster4 ABS druciak
; 0000 0C9E             a[6] = a[5]+0x001;  //okrag
; 0000 0C9F             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CA0 
; 0000 0CA1     break;
; 0000 0CA2 
; 0000 0CA3 
; 0000 0CA4     case 90:
_0x10A:
	CPI  R30,LOW(0x5A)
	LDI  R26,HIGH(0x5A)
	CPC  R31,R26
	BRNE _0x10B
; 0000 0CA5 
; 0000 0CA6             a[0] = 0x0F0;   //ster1
	LDI  R30,LOW(240)
	LDI  R31,HIGH(240)
	CALL SUBOPT_0x3C
; 0000 0CA7             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0CA8             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3E
; 0000 0CA9             a[5] = 0x196;   //delta okrag
; 0000 0CAA             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x49B
; 0000 0CAB             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0CAC 
; 0000 0CAD             a[1] = a[0]+0x001;  //ster2
; 0000 0CAE             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CAF             a[6] = a[5]+0x001;  //okrag
; 0000 0CB0             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CB1 
; 0000 0CB2     break;
; 0000 0CB3 
; 0000 0CB4 
; 0000 0CB5     case 91:
_0x10B:
	CPI  R30,LOW(0x5B)
	LDI  R26,HIGH(0x5B)
	CPC  R31,R26
	BRNE _0x10C
; 0000 0CB6 
; 0000 0CB7             a[0] = 0x0A8;   //ster1
	LDI  R30,LOW(168)
	LDI  R31,HIGH(168)
	CALL SUBOPT_0x3C
; 0000 0CB8             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0CB9             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x50
; 0000 0CBA             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x49D
; 0000 0CBB             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0CBC             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0CBD 
; 0000 0CBE             a[1] = a[0]+0x001;  //ster2
; 0000 0CBF             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CC0             a[6] = a[5]+0x001;  //okrag
; 0000 0CC1             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CC2 
; 0000 0CC3     break;
; 0000 0CC4 
; 0000 0CC5 
; 0000 0CC6     case 92:
_0x10C:
	CPI  R30,LOW(0x5C)
	LDI  R26,HIGH(0x5C)
	CPC  R31,R26
	BRNE _0x10D
; 0000 0CC7 
; 0000 0CC8             a[0] = 0x;   //ster1
	CALL SUBOPT_0x57
; 0000 0CC9             a[3] = 0x;    //ster4 INV druciak
; 0000 0CCA             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0CCB             a[5] = 0x;   //delta okrag
; 0000 0CCC             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0CCD             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0CCE 
; 0000 0CCF             a[1] = a[0]+0x001;  //ster2
; 0000 0CD0             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CD1             a[6] = a[5]+0x001;  //okrag
; 0000 0CD2             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CD3 
; 0000 0CD4     break;
; 0000 0CD5 
; 0000 0CD6 
; 0000 0CD7     case 93:
_0x10D:
	CPI  R30,LOW(0x5D)
	LDI  R26,HIGH(0x5D)
	CPC  R31,R26
	BRNE _0x10E
; 0000 0CD8 
; 0000 0CD9             a[0] = 0x030;   //ster1
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	CALL SUBOPT_0x3C
; 0000 0CDA             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0CDB             a[4] = 0x1A;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5C
; 0000 0CDC             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x49D
; 0000 0CDD             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0CDE             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0CDF 
; 0000 0CE0             a[1] = a[0]+0x001;  //ster2
; 0000 0CE1             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CE2             a[6] = a[5]+0x001;  //okrag
; 0000 0CE3             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CE4 
; 0000 0CE5     break;
; 0000 0CE6 
; 0000 0CE7 
; 0000 0CE8     case 94:
_0x10E:
	CPI  R30,LOW(0x5E)
	LDI  R26,HIGH(0x5E)
	CPC  R31,R26
	BRNE _0x10F
; 0000 0CE9 
; 0000 0CEA             a[0] = 0x0F4;   //ster1
	LDI  R30,LOW(244)
	LDI  R31,HIGH(244)
	CALL SUBOPT_0x3C
; 0000 0CEB             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0CEC             a[4] = 0x1B;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x3E
; 0000 0CED             a[5] = 0x196;   //delta okrag
; 0000 0CEE             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x45
; 0000 0CEF             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0CF0 
; 0000 0CF1             a[1] = a[0]+0x001;  //ster2
; 0000 0CF2             a[2] = a[4];        //ster4 ABS druciak
; 0000 0CF3             a[6] = a[5]+0x001;  //okrag
; 0000 0CF4             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0CF5 
; 0000 0CF6     break;
; 0000 0CF7 
; 0000 0CF8 
; 0000 0CF9     case 95:
_0x10F:
	CPI  R30,LOW(0x5F)
	LDI  R26,HIGH(0x5F)
	CPC  R31,R26
	BRNE _0x110
; 0000 0CFA 
; 0000 0CFB             a[0] = 0x09E;   //ster1
	LDI  R30,LOW(158)
	LDI  R31,HIGH(158)
	CALL SUBOPT_0x3C
; 0000 0CFC             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0CFD             a[4] = 0x20;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x4A
; 0000 0CFE             a[5] = 0x199;   //delta okrag
; 0000 0CFF             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D00             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0D01 
; 0000 0D02             a[1] = a[0]+0x001;  //ster2
; 0000 0D03             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D04             a[6] = a[5]+0x001;  //okrag
; 0000 0D05             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D06 
; 0000 0D07     break;
; 0000 0D08 
; 0000 0D09     case 96:
_0x110:
	CPI  R30,LOW(0x60)
	LDI  R26,HIGH(0x60)
	CPC  R31,R26
	BRNE _0x111
; 0000 0D0A 
; 0000 0D0B             a[0] = 0x;   //ster1
	CALL SUBOPT_0x57
; 0000 0D0C             a[3] = 0x;    //ster4 INV druciak
; 0000 0D0D             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0D0E             a[5] = 0x;   //delta okrag
; 0000 0D0F             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0D10             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0D11 
; 0000 0D12             a[1] = a[0]+0x001;  //ster2
; 0000 0D13             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D14             a[6] = a[5]+0x001;  //okrag
; 0000 0D15             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D16 
; 0000 0D17     break;
; 0000 0D18 
; 0000 0D19 
; 0000 0D1A     case 97:
_0x111:
	CPI  R30,LOW(0x61)
	LDI  R26,HIGH(0x61)
	CPC  R31,R26
	BRNE _0x112
; 0000 0D1B 
; 0000 0D1C             a[0] = 0x06A;   //ster1
	LDI  R30,LOW(106)
	LDI  R31,HIGH(106)
	CALL SUBOPT_0x3C
; 0000 0D1D             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0D1E             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x49
; 0000 0D1F             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x43
; 0000 0D20             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D21             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0D22 
; 0000 0D23             a[1] = a[0]+0x001;  //ster2
; 0000 0D24             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D25             a[6] = a[5]+0x001;  //okrag
; 0000 0D26             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D27 
; 0000 0D28     break;
; 0000 0D29 
; 0000 0D2A 
; 0000 0D2B     case 98:
_0x112:
	CPI  R30,LOW(0x62)
	LDI  R26,HIGH(0x62)
	CPC  R31,R26
	BRNE _0x113
; 0000 0D2C 
; 0000 0D2D             a[0] = 0x0BE;   //ster1
	LDI  R30,LOW(190)
	LDI  R31,HIGH(190)
	CALL SUBOPT_0x3C
; 0000 0D2E             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0D2F             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x42
; 0000 0D30             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x66
; 0000 0D31             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x45
; 0000 0D32             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0D33 
; 0000 0D34             a[1] = a[0]+0x001;  //ster2
; 0000 0D35             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D36             a[6] = a[5]+0x001;  //okrag
; 0000 0D37             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D38 
; 0000 0D39     break;
; 0000 0D3A 
; 0000 0D3B 
; 0000 0D3C     case 99:
_0x113:
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	BRNE _0x114
; 0000 0D3D 
; 0000 0D3E             a[0] = 0x0BA;   //ster1
	LDI  R30,LOW(186)
	LDI  R31,HIGH(186)
	CALL SUBOPT_0x3C
; 0000 0D3F             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0D40             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5F
; 0000 0D41             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP _0x49D
; 0000 0D42             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D43             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0D44 
; 0000 0D45             a[1] = a[0]+0x001;  //ster2
; 0000 0D46             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D47             a[6] = a[5]+0x001;  //okrag
; 0000 0D48             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D49 
; 0000 0D4A     break;
; 0000 0D4B 
; 0000 0D4C 
; 0000 0D4D     case 100:
_0x114:
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BRNE _0x115
; 0000 0D4E 
; 0000 0D4F             a[0] = 0x060;   //ster1
	LDI  R30,LOW(96)
	LDI  R31,HIGH(96)
	CALL SUBOPT_0x3C
; 0000 0D50             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0D51             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x44
; 0000 0D52             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x43
; 0000 0D53             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D54             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0D55 
; 0000 0D56             a[1] = a[0]+0x001;  //ster2
; 0000 0D57             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D58             a[6] = a[5]+0x001;  //okrag
; 0000 0D59             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D5A 
; 0000 0D5B     break;
; 0000 0D5C 
; 0000 0D5D 
; 0000 0D5E     case 101:
_0x115:
	CPI  R30,LOW(0x65)
	LDI  R26,HIGH(0x65)
	CPC  R31,R26
	BRNE _0x116
; 0000 0D5F 
; 0000 0D60             a[0] = 0x070;   //ster1
	LDI  R30,LOW(112)
	LDI  R31,HIGH(112)
	CALL SUBOPT_0x3C
; 0000 0D61             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0D62             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x49
; 0000 0D63             a[5] = 0x199;   //delta okrag
	RJMP _0x49D
; 0000 0D64             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D65             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0D66 
; 0000 0D67             a[1] = a[0]+0x001;  //ster2
; 0000 0D68             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D69             a[6] = a[5]+0x001;  //okrag
; 0000 0D6A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D6B 
; 0000 0D6C     break;
; 0000 0D6D 
; 0000 0D6E 
; 0000 0D6F     case 102:
_0x116:
	CPI  R30,LOW(0x66)
	LDI  R26,HIGH(0x66)
	CPC  R31,R26
	BRNE _0x117
; 0000 0D70 
; 0000 0D71             a[0] = 0x08A;   //ster1
	LDI  R30,LOW(138)
	LDI  R31,HIGH(138)
	CALL SUBOPT_0x3C
; 0000 0D72             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0D73             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x42
; 0000 0D74             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x66
; 0000 0D75             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x49B
; 0000 0D76             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0D77 
; 0000 0D78             a[1] = a[0]+0x001;  //ster2
; 0000 0D79             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D7A             a[6] = a[5]+0x001;  //okrag
; 0000 0D7B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D7C 
; 0000 0D7D     break;
; 0000 0D7E 
; 0000 0D7F 
; 0000 0D80     case 103:
_0x117:
	CPI  R30,LOW(0x67)
	LDI  R26,HIGH(0x67)
	CPC  R31,R26
	BRNE _0x118
; 0000 0D81 
; 0000 0D82             a[0] = 0x080;   //ster1
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CALL SUBOPT_0x3C
; 0000 0D83             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0D84             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5F
; 0000 0D85             a[5] = 0x199;   //delta okrag
	CALL SUBOPT_0x4D
; 0000 0D86             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D87             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0D88 
; 0000 0D89             a[1] = a[0]+0x001;  //ster2
; 0000 0D8A             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D8B             a[6] = a[5]+0x001;  //okrag
; 0000 0D8C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D8D 
; 0000 0D8E     break;
; 0000 0D8F 
; 0000 0D90 
; 0000 0D91     case 104:
_0x118:
	CPI  R30,LOW(0x68)
	LDI  R26,HIGH(0x68)
	CPC  R31,R26
	BRNE _0x119
; 0000 0D92 
; 0000 0D93             a[0] = 0x0B6;   //ster1
	LDI  R30,LOW(182)
	LDI  R31,HIGH(182)
	CALL SUBOPT_0x3C
; 0000 0D94             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0D95             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x44
; 0000 0D96             a[5] = 0x196;   //delta okrag
	RJMP _0x49D
; 0000 0D97             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0D98             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0D99 
; 0000 0D9A             a[1] = a[0]+0x001;  //ster2
; 0000 0D9B             a[2] = a[4];        //ster4 ABS druciak
; 0000 0D9C             a[6] = a[5]+0x001;  //okrag
; 0000 0D9D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0D9E 
; 0000 0D9F     break;
; 0000 0DA0 
; 0000 0DA1 
; 0000 0DA2     case 105:
_0x119:
	CPI  R30,LOW(0x69)
	LDI  R26,HIGH(0x69)
	CPC  R31,R26
	BRNE _0x11A
; 0000 0DA3 
; 0000 0DA4             a[0] = 0x044;   //ster1
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	CALL SUBOPT_0x3C
; 0000 0DA5             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0DA6             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x67
; 0000 0DA7             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x4E
; 0000 0DA8             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x45
; 0000 0DA9             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0DAA 
; 0000 0DAB             a[1] = a[0]+0x001;  //ster2
; 0000 0DAC             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DAD             a[6] = a[5]+0x001;  //okrag
; 0000 0DAE             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DAF 
; 0000 0DB0     break;
; 0000 0DB1 
; 0000 0DB2 
; 0000 0DB3     case 106:
_0x11A:
	CPI  R30,LOW(0x6A)
	LDI  R26,HIGH(0x6A)
	CPC  R31,R26
	BRNE _0x11B
; 0000 0DB4 
; 0000 0DB5             a[0] = 0x03A;   //ster1
	LDI  R30,LOW(58)
	LDI  R31,HIGH(58)
	CALL SUBOPT_0x3C
; 0000 0DB6             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0DB7             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x53
; 0000 0DB8             a[5] = 0x190;   //delta okrag
; 0000 0DB9             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x49B
; 0000 0DBA             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0DBB 
; 0000 0DBC             a[1] = a[0]+0x001;  //ster2
; 0000 0DBD             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DBE             a[6] = a[5]+0x001;  //okrag
; 0000 0DBF             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DC0 
; 0000 0DC1     break;
; 0000 0DC2 
; 0000 0DC3 
; 0000 0DC4     case 107:
_0x11B:
	CPI  R30,LOW(0x6B)
	LDI  R26,HIGH(0x6B)
	CPC  R31,R26
	BRNE _0x11C
; 0000 0DC5 
; 0000 0DC6             a[0] = 0x;   //ster1
	CALL SUBOPT_0x57
; 0000 0DC7             a[3] = 0x;    //ster4 INV druciak
; 0000 0DC8             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0DC9             a[5] = 0x;   //delta okrag
; 0000 0DCA             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0DCB             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0DCC 
; 0000 0DCD             a[1] = a[0]+0x001;  //ster2
; 0000 0DCE             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DCF             a[6] = a[5]+0x001;  //okrag
; 0000 0DD0             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DD1 
; 0000 0DD2     break;
; 0000 0DD3 
; 0000 0DD4 
; 0000 0DD5     case 108:
_0x11C:
	CPI  R30,LOW(0x6C)
	LDI  R26,HIGH(0x6C)
	CPC  R31,R26
	BRNE _0x11D
; 0000 0DD6 
; 0000 0DD7             a[0] = 0x0C6;   //ster1
	LDI  R30,LOW(198)
	LDI  R31,HIGH(198)
	CALL SUBOPT_0x3C
; 0000 0DD8             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0DD9             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5B
; 0000 0DDA             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5E
; 0000 0DDB             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x45
; 0000 0DDC             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0DDD 
; 0000 0DDE             a[1] = a[0]+0x001;  //ster2
; 0000 0DDF             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DE0             a[6] = a[5]+0x001;  //okrag
; 0000 0DE1             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DE2 
; 0000 0DE3     break;
; 0000 0DE4 
; 0000 0DE5 
; 0000 0DE6     case 109:
_0x11D:
	CPI  R30,LOW(0x6D)
	LDI  R26,HIGH(0x6D)
	CPC  R31,R26
	BRNE _0x11E
; 0000 0DE7 
; 0000 0DE8             a[0] = 0x00A;   //ster1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x3C
; 0000 0DE9             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3F
; 0000 0DEA             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x40
; 0000 0DEB             a[5] = 0x190;   //delta okrag
; 0000 0DEC             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x49B
; 0000 0DED             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0DEE 
; 0000 0DEF             a[1] = a[0]+0x001;  //ster2
; 0000 0DF0             a[2] = a[4];        //ster4 ABS druciak
; 0000 0DF1             a[6] = a[5]+0x001;  //okrag
; 0000 0DF2             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0DF3 
; 0000 0DF4     break;
; 0000 0DF5 
; 0000 0DF6 
; 0000 0DF7     case 110:
_0x11E:
	CPI  R30,LOW(0x6E)
	LDI  R26,HIGH(0x6E)
	CPC  R31,R26
	BRNE _0x11F
; 0000 0DF8 
; 0000 0DF9             a[0] = 0x032;   //ster1
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL SUBOPT_0x3C
; 0000 0DFA             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0DFB             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x53
; 0000 0DFC             a[5] = 0x190;   //delta okrag
; 0000 0DFD             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x45
; 0000 0DFE             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0DFF 
; 0000 0E00             a[1] = a[0]+0x001;  //ster2
; 0000 0E01             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E02             a[6] = a[5]+0x001;  //okrag
; 0000 0E03             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E04 
; 0000 0E05     break;
; 0000 0E06 
; 0000 0E07 
; 0000 0E08     case 111:
_0x11F:
	CPI  R30,LOW(0x6F)
	LDI  R26,HIGH(0x6F)
	CPC  R31,R26
	BRNE _0x120
; 0000 0E09 
; 0000 0E0A             a[0] = 0x;   //ster1
	CALL SUBOPT_0x57
; 0000 0E0B             a[3] = 0x;    //ster4 INV druciak
; 0000 0E0C             a[4] = 0x;    //ster3 ABS krazek scierny
; 0000 0E0D             a[5] = 0x;   //delta okrag
; 0000 0E0E             a[7] = 0x;    //ster3 INV krazek scierny
; 0000 0E0F             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0E10 
; 0000 0E11             a[1] = a[0]+0x001;  //ster2
; 0000 0E12             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E13             a[6] = a[5]+0x001;  //okrag
; 0000 0E14             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E15 
; 0000 0E16     break;
; 0000 0E17 
; 0000 0E18 
; 0000 0E19     case 112:
_0x120:
	CPI  R30,LOW(0x70)
	LDI  R26,HIGH(0x70)
	CPC  R31,R26
	BRNE _0x121
; 0000 0E1A 
; 0000 0E1B             a[0] = 0x0E2;   //ster1
	LDI  R30,LOW(226)
	LDI  R31,HIGH(226)
	CALL SUBOPT_0x3C
; 0000 0E1C             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0E1D             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5B
; 0000 0E1E             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5E
; 0000 0E1F             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x49B
; 0000 0E20             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0E21 
; 0000 0E22             a[1] = a[0]+0x001;  //ster2
; 0000 0E23             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E24             a[6] = a[5]+0x001;  //okrag
; 0000 0E25             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E26 
; 0000 0E27     break;
; 0000 0E28 
; 0000 0E29 
; 0000 0E2A     case 113:
_0x121:
	CPI  R30,LOW(0x71)
	LDI  R26,HIGH(0x71)
	CPC  R31,R26
	BRNE _0x122
; 0000 0E2B 
; 0000 0E2C             a[0] = 0x0D4;   //ster1
	LDI  R30,LOW(212)
	LDI  R31,HIGH(212)
	CALL SUBOPT_0x3C
; 0000 0E2D             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0E2E             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x68
; 0000 0E2F             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5E
; 0000 0E30             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x45
; 0000 0E31             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0E32 
; 0000 0E33             a[1] = a[0]+0x001;  //ster2
; 0000 0E34             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E35             a[6] = a[5]+0x001;  //okrag
; 0000 0E36             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E37 
; 0000 0E38     break;
; 0000 0E39 
; 0000 0E3A 
; 0000 0E3B     case 114:
_0x122:
	CPI  R30,LOW(0x72)
	LDI  R26,HIGH(0x72)
	CPC  R31,R26
	BRNE _0x123
; 0000 0E3C 
; 0000 0E3D             a[0] = 0x04A;   //ster1
	LDI  R30,LOW(74)
	LDI  R31,HIGH(74)
	CALL SUBOPT_0x3C
; 0000 0E3E             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3F
; 0000 0E3F             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x69
; 0000 0E40             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x64
; 0000 0E41             a[7] = 0x0F;    //ster3 INV krazek scierny
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	CALL SUBOPT_0x45
; 0000 0E42             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0E43 
; 0000 0E44             a[1] = a[0]+0x001;  //ster2
; 0000 0E45             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E46             a[6] = a[5]+0x001;  //okrag
; 0000 0E47             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E48 
; 0000 0E49     break;
; 0000 0E4A 
; 0000 0E4B 
; 0000 0E4C     case 115:
_0x123:
	CPI  R30,LOW(0x73)
	LDI  R26,HIGH(0x73)
	CPC  R31,R26
	BRNE _0x124
; 0000 0E4D 
; 0000 0E4E             a[0] = 0x076;   //ster1
	LDI  R30,LOW(118)
	LDI  R31,HIGH(118)
	CALL SUBOPT_0x3C
; 0000 0E4F             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x6A
; 0000 0E50             a[4] = 0x1F;    //ster3 ABS krazek scierny
; 0000 0E51             a[5] = 0x19C;   //delta okrag
	LDI  R26,LOW(412)
	LDI  R27,HIGH(412)
	CALL SUBOPT_0x46
; 0000 0E52             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x45
; 0000 0E53             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0E54 
; 0000 0E55             a[1] = a[0]+0x001;  //ster2
; 0000 0E56             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E57             a[6] = a[5]+0x001;  //okrag
; 0000 0E58             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E59 
; 0000 0E5A     break;
; 0000 0E5B 
; 0000 0E5C 
; 0000 0E5D     case 116:
_0x124:
	CPI  R30,LOW(0x74)
	LDI  R26,HIGH(0x74)
	CPC  R31,R26
	BRNE _0x125
; 0000 0E5E 
; 0000 0E5F             a[0] = 0x092;   //ster1
	LDI  R30,LOW(146)
	LDI  R31,HIGH(146)
	CALL SUBOPT_0x3C
; 0000 0E60             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0E61             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x51
; 0000 0E62             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x49D
; 0000 0E63             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0E64             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0E65 
; 0000 0E66             a[1] = a[0]+0x001;  //ster2
; 0000 0E67             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E68             a[6] = a[5]+0x001;  //okrag
; 0000 0E69             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E6A 
; 0000 0E6B     break;
; 0000 0E6C 
; 0000 0E6D 
; 0000 0E6E 
; 0000 0E6F     case 117:
_0x125:
	CPI  R30,LOW(0x75)
	LDI  R26,HIGH(0x75)
	CPC  R31,R26
	BRNE _0x126
; 0000 0E70 
; 0000 0E71             a[0] = 0x11A;   //ster1
	LDI  R30,LOW(282)
	LDI  R31,HIGH(282)
	CALL SUBOPT_0x3C
; 0000 0E72             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0E73             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x68
; 0000 0E74             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5E
; 0000 0E75             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x49B
; 0000 0E76             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0E77 
; 0000 0E78             a[1] = a[0]+0x001;  //ster2
; 0000 0E79             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E7A             a[6] = a[5]+0x001;  //okrag
; 0000 0E7B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E7C 
; 0000 0E7D     break;
; 0000 0E7E 
; 0000 0E7F 
; 0000 0E80 
; 0000 0E81     case 118:
_0x126:
	CPI  R30,LOW(0x76)
	LDI  R26,HIGH(0x76)
	CPC  R31,R26
	BRNE _0x127
; 0000 0E82 
; 0000 0E83             a[0] = 0x056;   //ster1
	LDI  R30,LOW(86)
	LDI  R31,HIGH(86)
	CALL SUBOPT_0x3C
; 0000 0E84             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3F
; 0000 0E85             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x69
; 0000 0E86             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5E
; 0000 0E87             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x49B
; 0000 0E88             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0E89 
; 0000 0E8A             a[1] = a[0]+0x001;  //ster2
; 0000 0E8B             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E8C             a[6] = a[5]+0x001;  //okrag
; 0000 0E8D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E8E 
; 0000 0E8F     break;
; 0000 0E90 
; 0000 0E91 
; 0000 0E92     case 119:
_0x127:
	CPI  R30,LOW(0x77)
	LDI  R26,HIGH(0x77)
	CPC  R31,R26
	BRNE _0x128
; 0000 0E93 
; 0000 0E94             a[0] = 0x072;   //ster1
	LDI  R30,LOW(114)
	LDI  R31,HIGH(114)
	CALL SUBOPT_0x3C
; 0000 0E95             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x6A
; 0000 0E96             a[4] = 0x1F;    //ster3 ABS krazek scierny
; 0000 0E97             a[5] = 0x19C;   //delta okrag
	LDI  R26,LOW(412)
	LDI  R27,HIGH(412)
	CALL SUBOPT_0x46
; 0000 0E98             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x49B
; 0000 0E99             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0E9A 
; 0000 0E9B             a[1] = a[0]+0x001;  //ster2
; 0000 0E9C             a[2] = a[4];        //ster4 ABS druciak
; 0000 0E9D             a[6] = a[5]+0x001;  //okrag
; 0000 0E9E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0E9F 
; 0000 0EA0     break;
; 0000 0EA1 
; 0000 0EA2 
; 0000 0EA3     case 120:
_0x128:
	CPI  R30,LOW(0x78)
	LDI  R26,HIGH(0x78)
	CPC  R31,R26
	BRNE _0x129
; 0000 0EA4 
; 0000 0EA5             a[0] = 0x0D0;   //ster1
	LDI  R30,LOW(208)
	LDI  R31,HIGH(208)
	CALL SUBOPT_0x3C
; 0000 0EA6             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0EA7             a[4] = 0x21;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x51
; 0000 0EA8             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x52
; 0000 0EA9             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0EAA             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0EAB 
; 0000 0EAC             a[1] = a[0]+0x001;  //ster2
; 0000 0EAD             a[2] = a[4];        //ster4 ABS druciak
; 0000 0EAE             a[6] = a[5]+0x001;  //okrag
; 0000 0EAF             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0EB0 
; 0000 0EB1     break;
; 0000 0EB2 
; 0000 0EB3 
; 0000 0EB4     case 121:
_0x129:
	CPI  R30,LOW(0x79)
	LDI  R26,HIGH(0x79)
	CPC  R31,R26
	BRNE _0x12A
; 0000 0EB5 
; 0000 0EB6             a[0] = 0x048;   //ster1
	LDI  R30,LOW(72)
	LDI  R31,HIGH(72)
	CALL SUBOPT_0x3C
; 0000 0EB7             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3F
; 0000 0EB8             a[4] = 0x1D;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x69
; 0000 0EB9             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5E
; 0000 0EBA             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x45
; 0000 0EBB             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0EBC 
; 0000 0EBD             a[1] = a[0]+0x001;  //ster2
; 0000 0EBE             a[2] = a[4];        //ster4 ABS druciak
; 0000 0EBF             a[6] = a[5]+0x001;  //okrag
; 0000 0EC0             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0EC1 
; 0000 0EC2     break;
; 0000 0EC3 
; 0000 0EC4 
; 0000 0EC5     case 122:
_0x12A:
	CPI  R30,LOW(0x7A)
	LDI  R26,HIGH(0x7A)
	CPC  R31,R26
	BRNE _0x12B
; 0000 0EC6 
; 0000 0EC7             a[0] = 0x09A;   //ster1
	LDI  R30,LOW(154)
	LDI  R31,HIGH(154)
	CALL SUBOPT_0x3C
; 0000 0EC8             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0EC9             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5F
; 0000 0ECA             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x52
; 0000 0ECB             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0ECC             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0ECD 
; 0000 0ECE             a[1] = a[0]+0x001;  //ster2
; 0000 0ECF             a[2] = a[4];        //ster4 ABS druciak
; 0000 0ED0             a[6] = a[5]+0x001;  //okrag
; 0000 0ED1             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0ED2 
; 0000 0ED3     break;
; 0000 0ED4 
; 0000 0ED5 
; 0000 0ED6     case 123:
_0x12B:
	CPI  R30,LOW(0x7B)
	LDI  R26,HIGH(0x7B)
	CPC  R31,R26
	BRNE _0x12C
; 0000 0ED7 
; 0000 0ED8             a[0] = 0x046;   //ster1
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	CALL SUBOPT_0x3C
; 0000 0ED9             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3F
; 0000 0EDA             a[4] = 0x17;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x6B
; 0000 0EDB             a[5] = 0x193;   //delta okrag
	CALL SUBOPT_0x6C
; 0000 0EDC             a[7] = 0x13;    //ster3 INV krazek scierny
	CALL SUBOPT_0x45
; 0000 0EDD             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0EDE 
; 0000 0EDF             a[1] = a[0]+0x001;  //ster2
; 0000 0EE0             a[2] = a[4];        //ster4 ABS druciak
; 0000 0EE1             a[6] = a[5]+0x001;  //okrag
; 0000 0EE2             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0EE3 
; 0000 0EE4     break;
; 0000 0EE5 
; 0000 0EE6 
; 0000 0EE7 
; 0000 0EE8     case 124:
_0x12C:
	CPI  R30,LOW(0x7C)
	LDI  R26,HIGH(0x7C)
	CPC  R31,R26
	BRNE _0x12D
; 0000 0EE9 
; 0000 0EEA             a[0] = 0x0E0;   //ster1
	LDI  R30,LOW(224)
	LDI  R31,HIGH(224)
	CALL SUBOPT_0x3C
; 0000 0EEB             a[3] = 0x0F;    //ster4 INV druciak
	CALL SUBOPT_0x6D
; 0000 0EEC             a[4] = 0x15;    //ster3 ABS krazek scierny
	LDI  R26,LOW(21)
	LDI  R27,HIGH(21)
	CALL SUBOPT_0x62
; 0000 0EED             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x64
; 0000 0EEE             a[7] = 0x13;    //ster3 INV krazek scierny
	LDI  R26,LOW(19)
	LDI  R27,HIGH(19)
	CALL SUBOPT_0x45
; 0000 0EEF             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0EF0 
; 0000 0EF1             a[1] = a[0]+0x001;  //ster2
; 0000 0EF2             a[2] = a[4];        //ster4 ABS druciak
; 0000 0EF3             a[6] = a[5]+0x001;  //okrag
; 0000 0EF4             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0EF5 
; 0000 0EF6     break;
; 0000 0EF7 
; 0000 0EF8 
; 0000 0EF9     case 125:
_0x12D:
	CPI  R30,LOW(0x7D)
	LDI  R26,HIGH(0x7D)
	CPC  R31,R26
	BRNE _0x12E
; 0000 0EFA 
; 0000 0EFB             a[0] = 0x038;   //ster1
	LDI  R30,LOW(56)
	LDI  R31,HIGH(56)
	CALL SUBOPT_0x3C
; 0000 0EFC             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0EFD             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5F
; 0000 0EFE             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x5E
; 0000 0EFF             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x49B
; 0000 0F00             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0F01 
; 0000 0F02             a[1] = a[0]+0x001;  //ster2
; 0000 0F03             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F04             a[6] = a[5]+0x001;  //okrag
; 0000 0F05             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F06 
; 0000 0F07     break;
; 0000 0F08 
; 0000 0F09 
; 0000 0F0A     case 126:
_0x12E:
	CPI  R30,LOW(0x7E)
	LDI  R26,HIGH(0x7E)
	CPC  R31,R26
	BRNE _0x12F
; 0000 0F0B 
; 0000 0F0C             a[0] = 0x0CA;   //ster1
	LDI  R30,LOW(202)
	LDI  R31,HIGH(202)
	CALL SUBOPT_0x3C
; 0000 0F0D             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0F0E             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5F
; 0000 0F0F             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x49D
; 0000 0F10             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0F11             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0F12 
; 0000 0F13             a[1] = a[0]+0x001;  //ster2
; 0000 0F14             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F15             a[6] = a[5]+0x001;  //okrag
; 0000 0F16             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F17 
; 0000 0F18     break;
; 0000 0F19 
; 0000 0F1A 
; 0000 0F1B     case 127:
_0x12F:
	CPI  R30,LOW(0x7F)
	LDI  R26,HIGH(0x7F)
	CPC  R31,R26
	BRNE _0x130
; 0000 0F1C 
; 0000 0F1D             a[0] = 0x0DE;   //ster1
	LDI  R30,LOW(222)
	LDI  R31,HIGH(222)
	CALL SUBOPT_0x3C
; 0000 0F1E             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3F
; 0000 0F1F             a[4] = 0x17;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x6B
; 0000 0F20             a[5] = 0x193;   //delta okrag
	CALL SUBOPT_0x6C
; 0000 0F21             a[7] = 0x13;    //ster3 INV krazek scierny
	RJMP _0x49B
; 0000 0F22             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0F23 
; 0000 0F24             a[1] = a[0]+0x001;  //ster2
; 0000 0F25             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F26             a[6] = a[5]+0x001;  //okrag
; 0000 0F27             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F28 
; 0000 0F29     break;
; 0000 0F2A 
; 0000 0F2B 
; 0000 0F2C     case 128:
_0x130:
	CPI  R30,LOW(0x80)
	LDI  R26,HIGH(0x80)
	CPC  R31,R26
	BRNE _0x131
; 0000 0F2D 
; 0000 0F2E             a[0] = 0x116;   //ster1
	LDI  R30,LOW(278)
	LDI  R31,HIGH(278)
	CALL SUBOPT_0x3C
; 0000 0F2F             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3F
; 0000 0F30             a[4] = 0x18;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x42
; 0000 0F31             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x6E
; 0000 0F32             a[7] = 0x13;    //ster3 INV krazek scierny
	RJMP _0x49B
; 0000 0F33             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0F34 
; 0000 0F35             a[1] = a[0]+0x001;  //ster2
; 0000 0F36             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F37             a[6] = a[5]+0x001;  //okrag
; 0000 0F38             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F39 
; 0000 0F3A     break;
; 0000 0F3B 
; 0000 0F3C 
; 0000 0F3D     case 129:
_0x131:
	CPI  R30,LOW(0x81)
	LDI  R26,HIGH(0x81)
	CPC  R31,R26
	BRNE _0x132
; 0000 0F3E 
; 0000 0F3F             a[0] = 0x0E8;   //ster1
	LDI  R30,LOW(232)
	LDI  R31,HIGH(232)
	CALL SUBOPT_0x3C
; 0000 0F40             a[3] = 0x0F;    //ster4 INV druciak
	CALL SUBOPT_0x6D
; 0000 0F41             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x6F
; 0000 0F42             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	CALL SUBOPT_0x6E
; 0000 0F43             a[7] = 0x13;    //ster3 INV krazek scierny
	CALL SUBOPT_0x45
; 0000 0F44             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0F45 
; 0000 0F46             a[1] = a[0]+0x001;  //ster2
; 0000 0F47             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F48             a[6] = a[5]+0x001;  //okrag
; 0000 0F49             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F4A 
; 0000 0F4B     break;
; 0000 0F4C 
; 0000 0F4D 
; 0000 0F4E     case 130:
_0x132:
	CPI  R30,LOW(0x82)
	LDI  R26,HIGH(0x82)
	CPC  R31,R26
	BRNE _0x133
; 0000 0F4F 
; 0000 0F50             a[0] = 0x0F2;   //ster1
	LDI  R30,LOW(242)
	LDI  R31,HIGH(242)
	CALL SUBOPT_0x3C
; 0000 0F51             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x70
; 0000 0F52             a[4] = 0x23;    //ster3 ABS krazek scierny
; 0000 0F53             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x64
; 0000 0F54             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3F
; 0000 0F55             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x41
	RJMP _0x49C
; 0000 0F56 
; 0000 0F57             a[1] = a[0]+0x001;  //ster2
; 0000 0F58             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F59             a[6] = a[5]+0x001;  //okrag
; 0000 0F5A             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F5B 
; 0000 0F5C     break;
; 0000 0F5D 
; 0000 0F5E 
; 0000 0F5F     case 131:
_0x133:
	CPI  R30,LOW(0x83)
	LDI  R26,HIGH(0x83)
	CPC  R31,R26
	BRNE _0x134
; 0000 0F60 
; 0000 0F61             a[0] = 0x108;   //ster1
	LDI  R30,LOW(264)
	LDI  R31,HIGH(264)
	CALL SUBOPT_0x3C
; 0000 0F62             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0F63             a[4] = 0x1F;    //ster3 ABS krazek scierny
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	RJMP _0x49E
; 0000 0F64             a[5] = 0x19C;   //delta okrag
; 0000 0F65             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0F66             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0F67 
; 0000 0F68             a[1] = a[0]+0x001;  //ster2
; 0000 0F69             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F6A             a[6] = a[5]+0x001;  //okrag
; 0000 0F6B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F6C 
; 0000 0F6D     break;
; 0000 0F6E 
; 0000 0F6F 
; 0000 0F70 
; 0000 0F71     case 132:
_0x134:
	CPI  R30,LOW(0x84)
	LDI  R26,HIGH(0x84)
	CPC  R31,R26
	BRNE _0x135
; 0000 0F72 
; 0000 0F73             a[0] = 0x064;   //ster1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x3C
; 0000 0F74             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0F75             a[4] = 0x1C;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x5B
; 0000 0F76             a[5] = 0x19C;   //delta okrag
	CALL SUBOPT_0x55
; 0000 0F77             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0F78             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0F79 
; 0000 0F7A             a[1] = a[0]+0x001;  //ster2
; 0000 0F7B             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F7C             a[6] = a[5]+0x001;  //okrag
; 0000 0F7D             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F7E 
; 0000 0F7F     break;
; 0000 0F80 
; 0000 0F81 
; 0000 0F82     case 133:
_0x135:
	CPI  R30,LOW(0x85)
	LDI  R26,HIGH(0x85)
	CPC  R31,R26
	BRNE _0x136
; 0000 0F83 
; 0000 0F84             a[0] = 0x088;   //ster1
	LDI  R30,LOW(136)
	LDI  R31,HIGH(136)
	CALL SUBOPT_0x3C
; 0000 0F85             a[3] = 0x0F;    //ster4 INV druciak
	CALL SUBOPT_0x6D
; 0000 0F86             a[4] = 0x18;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x6F
; 0000 0F87             a[5] = 0x199;   //delta okrag
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	CALL SUBOPT_0x6E
; 0000 0F88             a[7] = 0x13;    //ster3 INV krazek scierny
	RJMP _0x49B
; 0000 0F89             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0F8A 
; 0000 0F8B             a[1] = a[0]+0x001;  //ster2
; 0000 0F8C             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F8D             a[6] = a[5]+0x001;  //okrag
; 0000 0F8E             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0F8F 
; 0000 0F90     break;
; 0000 0F91 
; 0000 0F92 
; 0000 0F93 
; 0000 0F94     case 134:
_0x136:
	CPI  R30,LOW(0x86)
	LDI  R26,HIGH(0x86)
	CPC  R31,R26
	BRNE _0x137
; 0000 0F95 
; 0000 0F96             a[0] = 0x10E;   //ster1
	LDI  R30,LOW(270)
	LDI  R31,HIGH(270)
	CALL SUBOPT_0x3C
; 0000 0F97             a[3] = 0x12;    //ster4 INV druciak
	CALL SUBOPT_0x70
; 0000 0F98             a[4] = 0x23;    //ster3 ABS krazek scierny
; 0000 0F99             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x64
; 0000 0F9A             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x49B
; 0000 0F9B             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0F9C 
; 0000 0F9D             a[1] = a[0]+0x001;  //ster2
; 0000 0F9E             a[2] = a[4];        //ster4 ABS druciak
; 0000 0F9F             a[6] = a[5]+0x001;  //okrag
; 0000 0FA0             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FA1 
; 0000 0FA2     break;
; 0000 0FA3 
; 0000 0FA4                ////////////////////////////////////////////////////////////////////////////////////////////////////////
; 0000 0FA5      case 135:
_0x137:
	CPI  R30,LOW(0x87)
	LDI  R26,HIGH(0x87)
	CPC  R31,R26
	BRNE _0x138
; 0000 0FA6 
; 0000 0FA7             a[0] = 0x054;   //ster1
	LDI  R30,LOW(84)
	LDI  R31,HIGH(84)
	CALL SUBOPT_0x3C
; 0000 0FA8             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0FA9             a[4] = 0x1F;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x67
; 0000 0FAA             a[5] = 0x19C;   //delta okrag
	CALL SUBOPT_0x55
; 0000 0FAB             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0FAC             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0FAD 
; 0000 0FAE             a[1] = a[0]+0x001;  //ster2
; 0000 0FAF             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FB0             a[6] = a[5]+0x001;  //okrag
; 0000 0FB1             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FB2 
; 0000 0FB3     break;
; 0000 0FB4 
; 0000 0FB5 
; 0000 0FB6      case 136:
_0x138:
	CPI  R30,LOW(0x88)
	LDI  R26,HIGH(0x88)
	CPC  R31,R26
	BRNE _0x139
; 0000 0FB7 
; 0000 0FB8             a[0] = 0x03E;   //ster1
	LDI  R30,LOW(62)
	LDI  R31,HIGH(62)
	CALL SUBOPT_0x3C
; 0000 0FB9             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3F
; 0000 0FBA             a[4] = 0x18;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x6F
; 0000 0FBB             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x71
; 0000 0FBC             a[7] = 0x10;    //ster3 INV krazek scierny
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	RJMP _0x49B
; 0000 0FBD             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0FBE 
; 0000 0FBF             a[1] = a[0]+0x001;  //ster2
; 0000 0FC0             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FC1             a[6] = a[5]+0x001;  //okrag
; 0000 0FC2             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FC3 
; 0000 0FC4     break;
; 0000 0FC5 
; 0000 0FC6      case 137:
_0x139:
	CPI  R30,LOW(0x89)
	LDI  R26,HIGH(0x89)
	CPC  R31,R26
	BRNE _0x13A
; 0000 0FC7 
; 0000 0FC8             a[0] = 0x00C;   //ster1
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CALL SUBOPT_0x3C
; 0000 0FC9             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0FCA             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x53
; 0000 0FCB             a[5] = 0x190;   //delta okrag
; 0000 0FCC             a[7] = 0x0F;    //ster3 INV krazek scierny
	CALL SUBOPT_0x45
; 0000 0FCD             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 0FCE 
; 0000 0FCF             a[1] = a[0]+0x001;  //ster2
; 0000 0FD0             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FD1             a[6] = a[5]+0x001;  //okrag
; 0000 0FD2             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FD3 
; 0000 0FD4     break;
; 0000 0FD5 
; 0000 0FD6 
; 0000 0FD7      case 138:
_0x13A:
	CPI  R30,LOW(0x8A)
	LDI  R26,HIGH(0x8A)
	CPC  R31,R26
	BRNE _0x13B
; 0000 0FD8 
; 0000 0FD9             a[0] = 0x0DC;   //ster1
	LDI  R30,LOW(220)
	LDI  R31,HIGH(220)
	CALL SUBOPT_0x3C
; 0000 0FDA             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3F
; 0000 0FDB             a[4] = 0x1B;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x3E
; 0000 0FDC             a[5] = 0x196;   //delta okrag
; 0000 0FDD             a[7] = 0x11;    //ster3 INV krazek scierny
	RJMP _0x49B
; 0000 0FDE             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0FDF 
; 0000 0FE0             a[1] = a[0]+0x001;  //ster2
; 0000 0FE1             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FE2             a[6] = a[5]+0x001;  //okrag
; 0000 0FE3             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FE4 
; 0000 0FE5     break;
; 0000 0FE6 
; 0000 0FE7 
; 0000 0FE8      case 139:
_0x13B:
	CPI  R30,LOW(0x8B)
	LDI  R26,HIGH(0x8B)
	CPC  R31,R26
	BRNE _0x13C
; 0000 0FE9 
; 0000 0FEA             a[0] = 0x058;   //ster1
	LDI  R30,LOW(88)
	LDI  R31,HIGH(88)
	CALL SUBOPT_0x3C
; 0000 0FEB             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 0FEC             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x68
; 0000 0FED             a[5] = 0x196;   //delta okrag
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP _0x49D
; 0000 0FEE             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 0FEF             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 0FF0 
; 0000 0FF1             a[1] = a[0]+0x001;  //ster2
; 0000 0FF2             a[2] = a[4];        //ster4 ABS druciak
; 0000 0FF3             a[6] = a[5]+0x001;  //okrag
; 0000 0FF4             a[8] = a[6]+0x001;  //-delta okrag
; 0000 0FF5 
; 0000 0FF6     break;
; 0000 0FF7 
; 0000 0FF8 
; 0000 0FF9      case 140:
_0x13C:
	CPI  R30,LOW(0x8C)
	LDI  R26,HIGH(0x8C)
	CPC  R31,R26
	BRNE _0x13D
; 0000 0FFA 
; 0000 0FFB             a[0] = 0x03C;   //ster1
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL SUBOPT_0x3C
; 0000 0FFC             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3F
; 0000 0FFD             a[4] = 0x17;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x6B
; 0000 0FFE             a[5] = 0x190;   //delta okrag
	CALL SUBOPT_0x71
; 0000 0FFF             a[7] = 0x10;    //ster3 INV krazek scierny
	CALL SUBOPT_0x3F
; 0000 1000             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	CALL SUBOPT_0x41
	RJMP _0x49C
; 0000 1001 
; 0000 1002             a[1] = a[0]+0x001;  //ster2
; 0000 1003             a[2] = a[4];        //ster4 ABS druciak
; 0000 1004             a[6] = a[5]+0x001;  //okrag
; 0000 1005             a[8] = a[6]+0x001;  //-delta okrag
; 0000 1006 
; 0000 1007 
; 0000 1008 
; 0000 1009     break;
; 0000 100A 
; 0000 100B 
; 0000 100C      case 141:
_0x13D:
	CPI  R30,LOW(0x8D)
	LDI  R26,HIGH(0x8D)
	CPC  R31,R26
	BRNE _0x13E
; 0000 100D 
; 0000 100E             a[0] = 0x00E;   //ster1
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CALL SUBOPT_0x3C
; 0000 100F             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 1010             a[4] = 0x1E;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x53
; 0000 1011             a[5] = 0x190;   //delta okrag
; 0000 1012             a[7] = 0x0F;    //ster3 INV krazek scierny
	RJMP _0x49B
; 0000 1013             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 1014 
; 0000 1015             a[1] = a[0]+0x001;  //ster2
; 0000 1016             a[2] = a[4];        //ster4 ABS druciak
; 0000 1017             a[6] = a[5]+0x001;  //okrag
; 0000 1018             a[8] = a[6]+0x001;  //-delta okrag
; 0000 1019 
; 0000 101A     break;
; 0000 101B 
; 0000 101C 
; 0000 101D      case 142:
_0x13E:
	CPI  R30,LOW(0x8E)
	LDI  R26,HIGH(0x8E)
	CPC  R31,R26
	BRNE _0x13F
; 0000 101E 
; 0000 101F             a[0] = 0x10A;   //ster1
	LDI  R30,LOW(266)
	LDI  R31,HIGH(266)
	CALL SUBOPT_0x3C
; 0000 1020             a[3] = 0x10;    //ster4 INV druciak
	CALL SUBOPT_0x3F
; 0000 1021             a[4] = 0x1B;    //ster3 ABS krazek scierny
	__POINTW1MN _a,8
	CALL SUBOPT_0x3E
; 0000 1022             a[5] = 0x196;   //delta okrag
; 0000 1023             a[7] = 0x11;    //ster3 INV krazek scierny
	CALL SUBOPT_0x45
; 0000 1024             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 1025 
; 0000 1026             a[1] = a[0]+0x001;  //ster2
; 0000 1027             a[2] = a[4];        //ster4 ABS druciak
; 0000 1028             a[6] = a[5]+0x001;  //okrag
; 0000 1029             a[8] = a[6]+0x001;  //-delta okrag
; 0000 102A 
; 0000 102B     break;
; 0000 102C 
; 0000 102D 
; 0000 102E 
; 0000 102F      case 143:
_0x13F:
	CPI  R30,LOW(0x8F)
	LDI  R26,HIGH(0x8F)
	CPC  R31,R26
	BRNE _0x140
; 0000 1030 
; 0000 1031             a[0] = 0x022;   //ster1
	LDI  R30,LOW(34)
	LDI  R31,HIGH(34)
	CALL SUBOPT_0x3C
; 0000 1032             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 1033             a[4] = 0x19;    //ster3 ABS krazek scierny
	CALL SUBOPT_0x68
; 0000 1034             a[5] = 0x196;   //delta okrag
	CALL SUBOPT_0x52
; 0000 1035             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 1036             a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	RJMP _0x49C
; 0000 1037 
; 0000 1038             a[1] = a[0]+0x001;  //ster2
; 0000 1039             a[2] = a[4];        //ster4 ABS druciak
; 0000 103A             a[6] = a[5]+0x001;  //okrag
; 0000 103B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 103C 
; 0000 103D     break;
; 0000 103E 
; 0000 103F 
; 0000 1040      case 144:
_0x140:
	CPI  R30,LOW(0x90)
	LDI  R26,HIGH(0x90)
	CPC  R31,R26
	BRNE _0xB0
; 0000 1041 
; 0000 1042             a[0] = 0x066;   //ster1
	LDI  R30,LOW(102)
	LDI  R31,HIGH(102)
	CALL SUBOPT_0x3C
; 0000 1043             a[3] = 0x11;    //ster4 INV druciak
	CALL SUBOPT_0x3D
; 0000 1044             a[4] = 0x1C;    //ster3 ABS krazek scierny
	LDI  R26,LOW(28)
	LDI  R27,HIGH(28)
_0x49E:
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 1045             a[5] = 0x19C;   //delta okrag
	__POINTW1MN _a,10
	LDI  R26,LOW(412)
	LDI  R27,HIGH(412)
_0x49D:
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 1046             a[7] = 0x12;    //ster3 INV krazek scierny
	__POINTW1MN _a,14
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
_0x49B:
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 1047             a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
	__POINTW1MN _a,18
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
_0x49C:
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 1048 
; 0000 1049             a[1] = a[0]+0x001;  //ster2
	CALL SUBOPT_0x72
	ADIW R30,1
	__PUTW1MN _a,2
; 0000 104A             a[2] = a[4];        //ster4 ABS druciak
	CALL SUBOPT_0x73
	__PUTW1MN _a,4
; 0000 104B             a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x74
	CALL SUBOPT_0x75
; 0000 104C             a[8] = a[6]+0x001;  //-delta okrag
; 0000 104D 
; 0000 104E     break;
; 0000 104F 
; 0000 1050 
; 0000 1051 }
_0xB0:
; 0000 1052 
; 0000 1053 if(predkosc_pion_szczotka == 50)   //zwolnienie predkosci pion
	LDS  R26,_predkosc_pion_szczotka
	LDS  R27,_predkosc_pion_szczotka+1
	SBIW R26,50
	BRNE _0x142
; 0000 1054        {
; 0000 1055        a[3] = a[3] - 0x05;
	CALL SUBOPT_0x76
	SBIW R30,5
	__PUTW1MN _a,6
; 0000 1056        }
; 0000 1057 if(predkosc_pion_krazek == 50)   //zwolnienie predkosci pion
_0x142:
	LDS  R26,_predkosc_pion_krazek
	LDS  R27,_predkosc_pion_krazek+1
	SBIW R26,50
	BRNE _0x143
; 0000 1058        {
; 0000 1059        a[7] = a[7] - 0x05;
	__GETW1MN _a,14
	SBIW R30,5
	__PUTW1MN _a,14
; 0000 105A        }
; 0000 105B 
; 0000 105C 
; 0000 105D //if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 1 & predkosc_ruchow_po_okregu_krazek_scierny == 50)
; 0000 105E     //{
; 0000 105F     //nic
; 0000 1060     //}
; 0000 1061 
; 0000 1062 
; 0000 1063 if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 2 & predkosc_ruchow_po_okregu_krazek_scierny == 50)
_0x143:
	CALL SUBOPT_0x77
	CALL SUBOPT_0x78
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL __EQW12
	AND  R30,R0
	BREQ _0x144
; 0000 1064     {
; 0000 1065     a[5] = a[5] + 0x10;   //plus 16 dzesietnie
	CALL SUBOPT_0x74
	ADIW R30,16
	CALL SUBOPT_0x79
; 0000 1066     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x75
; 0000 1067     a[8] = a[6]+0x001;  //-delta okrag
; 0000 1068     }
; 0000 1069 
; 0000 106A if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 1 & predkosc_ruchow_po_okregu_krazek_scierny == 10)
_0x144:
	CALL SUBOPT_0x77
	CALL SUBOPT_0x7A
	MOV  R0,R30
	LDS  R26,_predkosc_ruchow_po_okregu_krazek_scierny
	LDS  R27,_predkosc_ruchow_po_okregu_krazek_scierny+1
	CALL SUBOPT_0x7B
	BREQ _0x145
; 0000 106B     {
; 0000 106C     a[5] = a[5] + 0x20;   //plus 32 dzesietnie
	CALL SUBOPT_0x74
	ADIW R30,32
	CALL SUBOPT_0x79
; 0000 106D     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x75
; 0000 106E     a[8] = a[6]+0x001;  //-delta okrag
; 0000 106F     }
; 0000 1070 
; 0000 1071 
; 0000 1072 if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 2 & predkosc_ruchow_po_okregu_krazek_scierny == 10)
_0x145:
	CALL SUBOPT_0x77
	CALL SUBOPT_0x78
	CALL SUBOPT_0x7B
	BREQ _0x146
; 0000 1073     {
; 0000 1074     a[5] = a[5] + 0x30;   //plus 48 dzesietnie
	CALL SUBOPT_0x74
	ADIW R30,48
	CALL SUBOPT_0x79
; 0000 1075     a[6] = a[5]+0x001;  //okrag
	CALL SUBOPT_0x75
; 0000 1076     a[8] = a[6]+0x001;  //-delta okrag
; 0000 1077     }
; 0000 1078 
; 0000 1079 
; 0000 107A 
; 0000 107B 
; 0000 107C 
; 0000 107D 
; 0000 107E 
; 0000 107F 
; 0000 1080      /*
; 0000 1081         a[0] = 0x05A;   //ster1
; 0000 1082             a[3] = 0x11;    //ster4 INV druciak
; 0000 1083             a[4] = 0x21;    //ster3 ABS krazek scierny
; 0000 1084             a[5] = 0x196;   //delta okrag
; 0000 1085             a[7] = 0x12;    //ster3 INV krazek scierny
; 0000 1086             a[9] = 0;       //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
; 0000 1087 
; 0000 1088             a[1] = a[0]+0x001;  //ster2
; 0000 1089             a[2] = a[4];        //ster4 ABS druciak
; 0000 108A             a[6] = a[5]+0x001;  //okrag
; 0000 108B             a[8] = a[6]+0x001;  //-delta okrag
; 0000 108C         */
; 0000 108D }
_0x146:
	ADIW R28,2
	RET
;
;
;void wartosci_wstepne_panelu()
; 0000 1091 {
_wartosci_wstepne_panelu:
; 0000 1092                                                       //3040
; 0000 1093 wartosc_parametru_panelu(szczotka_druciana_ilosc_cykli,48,64);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x1D
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x11
	CALL SUBOPT_0x7C
; 0000 1094                                                 //2090
; 0000 1095 wartosc_parametru_panelu(krazek_scierny_ilosc_cykli,32,144);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x7D
	CALL SUBOPT_0xF
	CALL _wartosc_parametru_panelu
; 0000 1096                                                         //3000
; 0000 1097 wartosc_parametru_panelu(krazek_scierny_cykl_po_okregu_ilosc,48,0);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x1F
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	CALL SUBOPT_0xE
	CALL _wartosc_parametru_panelu
; 0000 1098                                                 //2050
; 0000 1099 wartosc_parametru_panelu(predkosc_pion_szczotka,32,80);
	LDS  R30,_predkosc_pion_szczotka
	LDS  R31,_predkosc_pion_szczotka+1
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x2E
	CALL _wartosc_parametru_panelu
; 0000 109A                                                 //2060
; 0000 109B wartosc_parametru_panelu(predkosc_pion_krazek,32,96);
	LDS  R30,_predkosc_pion_krazek
	LDS  R31,_predkosc_pion_krazek+1
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x2F
	CALL _wartosc_parametru_panelu
; 0000 109C                                                                        //3010
; 0000 109D wartosc_parametru_panelu(wejscie_krazka_sciernego_w_pow_boczna_cylindra,48,16);
	LDS  R30,_wejscie_krazka_sciernego_w_pow_boczna_cylindra
	LDS  R31,_wejscie_krazka_sciernego_w_pow_boczna_cylindra+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	CALL SUBOPT_0x10
	CALL _wartosc_parametru_panelu
; 0000 109E                                                                      //2070
; 0000 109F wartosc_parametru_panelu(predkosc_ruchow_po_okregu_krazek_scierny,32,112);
	LDS  R30,_predkosc_ruchow_po_okregu_krazek_scierny
	LDS  R31,_predkosc_ruchow_po_okregu_krazek_scierny+1
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x2D
	CALL _wartosc_parametru_panelu
; 0000 10A0 
; 0000 10A1 wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_stala,16,112);
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x10
	CALL SUBOPT_0x2D
	CALL _wartosc_parametru_panelu
; 0000 10A2 
; 0000 10A3 wartosc_parametru_panelu(czas_pracy_krazka_sciernego_stala,32,16);
	CALL SUBOPT_0x1B
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	CALL SUBOPT_0x10
	CALL _wartosc_parametru_panelu
; 0000 10A4 
; 0000 10A5 wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_h,0,144);
	CALL SUBOPT_0x9
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
	CALL _wartosc_parametru_panelu
; 0000 10A6 
; 0000 10A7 wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h,16,48);
	CALL SUBOPT_0xB
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
	CALL _wartosc_parametru_panelu
; 0000 10A8 
; 0000 10A9 }
	RET
;
;void wypozycjonuj_napedy_minimalistyczna()
; 0000 10AC {
_wypozycjonuj_napedy_minimalistyczna:
; 0000 10AD 
; 0000 10AE while(start == 0)
_0x147:
	MOV  R0,R12
	OR   R0,R13
	BRNE _0x149
; 0000 10AF     {
; 0000 10B0     komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x31
; 0000 10B1     komunikat_na_panel("Nacisnij START aby wypozycjonowac napedy",adr1,adr2);
	__POINTW1FN _0x0,1344
	CALL SUBOPT_0x3B
; 0000 10B2     komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x7E
; 0000 10B3     komunikat_na_panel("Nacisnij START aby wypozycjonowac napedy",adr3,adr4);
	__POINTW1FN _0x0,1344
	CALL SUBOPT_0x7F
; 0000 10B4     delay_ms(1000);
	CALL SUBOPT_0x80
; 0000 10B5     start = odczytaj_parametr(0,64);
	CALL SUBOPT_0x24
	CALL SUBOPT_0x25
	MOVW R12,R30
; 0000 10B6     }
	RJMP _0x147
_0x149:
; 0000 10B7 
; 0000 10B8 
; 0000 10B9 while(sprawdz_pin0(PORTMM,0x77) == 1 | sprawdz_pin1(PORTMM,0x77) == 1)
_0x14A:
	CALL SUBOPT_0x23
	CALL SUBOPT_0x81
	PUSH R30
	CALL SUBOPT_0x23
	CALL SUBOPT_0x82
	POP  R26
	OR   R30,R26
	BRNE _0x14A
; 0000 10BA     {
; 0000 10BB     //krancowki
; 0000 10BC     }
; 0000 10BD 
; 0000 10BE 
; 0000 10BF PORTD.2 = 1;   //setup wspolny
	SBI  0x12,2
; 0000 10C0 delay_ms(1000);
	CALL SUBOPT_0x80
; 0000 10C1 
; 0000 10C2 
; 0000 10C3 
; 0000 10C4 
; 0000 10C5 while(sprawdz_pin3(PORTJJ,0x79) == 1 | sprawdz_pin3(PORTLL,0x71) == 1 |
_0x14F:
; 0000 10C6       sprawdz_pin3(PORTKK,0x75) == 1 | sprawdz_pin7(PORTKK,0x75) == 1)
	CALL SUBOPT_0x30
	CALL SUBOPT_0x83
	PUSH R30
	CALL SUBOPT_0x84
	CALL SUBOPT_0x83
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x85
	CALL SUBOPT_0x83
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x85
	CALL SUBOPT_0x86
	POP  R26
	OR   R30,R26
	BRNE PC+3
	JMP _0x151
; 0000 10C7       {
; 0000 10C8 
; 0000 10C9       if(sprawdz_pin0(PORTMM,0x77) == 1 | sprawdz_pin1(PORTMM,0x77) == 1)
	CALL SUBOPT_0x23
	CALL SUBOPT_0x81
	PUSH R30
	CALL SUBOPT_0x23
	CALL SUBOPT_0x82
	POP  R26
	OR   R30,R26
	BREQ _0x152
; 0000 10CA         while(1)
_0x153:
; 0000 10CB             {
; 0000 10CC             PORTD.7 = 1;
	SBI  0x12,7
; 0000 10CD             }
	RJMP _0x153
; 0000 10CE 
; 0000 10CF 
; 0000 10D0       komunikat_na_panel("                                                ",adr1,adr2);
_0x152:
	CALL SUBOPT_0x31
; 0000 10D1       komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr1,adr2);
	__POINTW1FN _0x0,1385
	CALL SUBOPT_0x3B
; 0000 10D2       komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x7E
; 0000 10D3       komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr3,adr4);
	__POINTW1FN _0x0,1385
	CALL SUBOPT_0x7F
; 0000 10D4       delay_ms(1000);
	CALL SUBOPT_0x80
; 0000 10D5 
; 0000 10D6       if(sprawdz_pin3(PORTJJ,0x79) == 0)
	CALL SUBOPT_0x30
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x158
; 0000 10D7             {
; 0000 10D8             komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x31
; 0000 10D9             komunikat_na_panel("Sterownik 1 - wypozycjonowalem",adr1,adr2);
	__POINTW1FN _0x0,1416
	CALL SUBOPT_0x3B
; 0000 10DA             delay_ms(1000);
	CALL SUBOPT_0x80
; 0000 10DB             }
; 0000 10DC       if(sprawdz_pin3(PORTLL,0x71) == 0)
_0x158:
	CALL SUBOPT_0x84
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x159
; 0000 10DD             {
; 0000 10DE             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x7E
; 0000 10DF             komunikat_na_panel("Sterownik 2 - wypozycjonowalem",adr3,adr4);
	__POINTW1FN _0x0,1447
	CALL SUBOPT_0x7F
; 0000 10E0             delay_ms(1000);
	CALL SUBOPT_0x80
; 0000 10E1             }
; 0000 10E2       if(sprawdz_pin3(PORTKK,0x75) == 0)
_0x159:
	CALL SUBOPT_0x85
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x15A
; 0000 10E3             {
; 0000 10E4             komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x31
; 0000 10E5             komunikat_na_panel("Sterownik 3 - wypozycjonowalem",adr1,adr2);
	__POINTW1FN _0x0,1478
	CALL SUBOPT_0x3B
; 0000 10E6             delay_ms(1000);
	CALL SUBOPT_0x80
; 0000 10E7             }
; 0000 10E8       if(sprawdz_pin7(PORTKK,0x75) == 0)
_0x15A:
	CALL SUBOPT_0x85
	CALL _sprawdz_pin7
	CPI  R30,0
	BRNE _0x15B
; 0000 10E9             {
; 0000 10EA             komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x7E
; 0000 10EB             komunikat_na_panel("Sterownik 4 - wypozycjonowalem",adr1,adr2);
	__POINTW1FN _0x0,1509
	CALL SUBOPT_0x3B
; 0000 10EC             delay_ms(1000);
	CALL SUBOPT_0x80
; 0000 10ED             }
; 0000 10EE 
; 0000 10EF 
; 0000 10F0 
; 0000 10F1        if(sprawdz_pin7(PORTMM,0x77) == 1)
_0x15B:
	CALL SUBOPT_0x23
	CALL _sprawdz_pin7
	CPI  R30,LOW(0x1)
	BRNE _0x15C
; 0000 10F2             PORTD.7 = 1;
	SBI  0x12,7
; 0000 10F3 
; 0000 10F4       if(sprawdz_pin6(PORTMM,0x77) == 1 |
_0x15C:
; 0000 10F5          sprawdz_pin7(PORTMM,0x77) == 1 |
; 0000 10F6          sprawdz_pin5(PORTJJ,0x79) == 1 |
; 0000 10F7          sprawdz_pin5(PORTLL,0x71) == 1)
	CALL SUBOPT_0x23
	CALL SUBOPT_0x87
	PUSH R30
	CALL SUBOPT_0x23
	CALL SUBOPT_0x86
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x30
	CALL SUBOPT_0x88
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x84
	CALL SUBOPT_0x88
	POP  R26
	OR   R30,R26
	BREQ _0x15F
; 0000 10F8             {
; 0000 10F9             PORTD.7 = 1;
	SBI  0x12,7
; 0000 10FA             if(sprawdz_pin6(PORTMM,0x77) == 1)
	CALL SUBOPT_0x23
	CALL _sprawdz_pin6
	CPI  R30,LOW(0x1)
	BRNE _0x162
; 0000 10FB                 {
; 0000 10FC                 komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x31
; 0000 10FD                 komunikat_na_panel("Alarm Sterownik 4",adr1,adr2);
	__POINTW1FN _0x0,1540
	CALL SUBOPT_0x3B
; 0000 10FE                 delay_ms(1000);
	CALL SUBOPT_0x80
; 0000 10FF                 }
; 0000 1100             if(sprawdz_pin7(PORTMM,0x77) == 1)
_0x162:
	CALL SUBOPT_0x23
	CALL _sprawdz_pin7
	CPI  R30,LOW(0x1)
	BRNE _0x163
; 0000 1101                 {
; 0000 1102                 komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x31
; 0000 1103                 komunikat_na_panel("Alarm Sterownik 3",adr1,adr2);
	__POINTW1FN _0x0,1558
	CALL SUBOPT_0x3B
; 0000 1104                 delay_ms(1000);
	CALL SUBOPT_0x80
; 0000 1105                 }
; 0000 1106             if(sprawdz_pin5(PORTJJ,0x79) == 1)
_0x163:
	CALL SUBOPT_0x30
	CALL _sprawdz_pin5
	CPI  R30,LOW(0x1)
	BRNE _0x164
; 0000 1107                 {
; 0000 1108                 komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x31
; 0000 1109                 komunikat_na_panel("Alarm Sterownik 1",adr1,adr2);
	__POINTW1FN _0x0,1576
	CALL SUBOPT_0x3B
; 0000 110A                 delay_ms(1000);
	CALL SUBOPT_0x80
; 0000 110B                 }
; 0000 110C             if(sprawdz_pin5(PORTLL,0x71) == 1)
_0x164:
	CALL SUBOPT_0x84
	CALL _sprawdz_pin5
	CPI  R30,LOW(0x1)
	BRNE _0x165
; 0000 110D                 {
; 0000 110E                 komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x31
; 0000 110F                 komunikat_na_panel("Alarm Sterownik 2",adr1,adr2);
	__POINTW1FN _0x0,1594
	CALL SUBOPT_0x3B
; 0000 1110                 delay_ms(1000);
	CALL SUBOPT_0x80
; 0000 1111                 }
; 0000 1112 
; 0000 1113             }
_0x165:
; 0000 1114 
; 0000 1115       //sprawdz_pin6(PORTMM,0x77) ALARM STEROWNIK4
; 0000 1116 //sprawdz_pin7(PORTMM,0x77) ALARM STEROWNIK3
; 0000 1117       //sprawdz_pin5(PORTJJ,0x79)  ALARM  STEROWNIK1
; 0000 1118        //sprawdz_pin5(PORTLL,0x71)  ALARM  STEROWNIK2
; 0000 1119 
; 0000 111A 
; 0000 111B 
; 0000 111C       }
_0x15F:
	RJMP _0x14F
_0x151:
; 0000 111D 
; 0000 111E komunikat_na_panel("                                                ",adr1,adr2);
	CALL SUBOPT_0x31
; 0000 111F komunikat_na_panel("Wypozycjonowano uklady liniowe XYZ",adr1,adr2);
	__POINTW1FN _0x0,1612
	CALL SUBOPT_0x3B
; 0000 1120 komunikat_na_panel("                                                ",adr3,adr4);
	CALL SUBOPT_0x7E
; 0000 1121 komunikat_na_panel("Wypozycjonowano uklady liniowe XYZ",adr3,adr4);
	__POINTW1FN _0x0,1612
	CALL SUBOPT_0x7F
; 0000 1122 
; 0000 1123 PORTD.2 = 0;   //setup wspolny
	CBI  0x12,2
; 0000 1124 delay_ms(1000);
	CALL SUBOPT_0x80
; 0000 1125 wartosc_parametru_panelu(0,0,64);  //start na 0;
	CALL SUBOPT_0x89
	CALL SUBOPT_0x7C
; 0000 1126 start = 0;
	CLR  R12
	CLR  R13
; 0000 1127 
; 0000 1128 }
	RET
;
;int wypozycjonuj_LEFS32_300_1(int step)
; 0000 112B {
; 0000 112C //PORTF.0   IN0  STEROWNIK3
; 0000 112D //PORTF.1   IN1  STEROWNIK3
; 0000 112E //PORTF.2   IN2  STEROWNIK3
; 0000 112F //PORTF.3   IN3  STEROWNIK3
; 0000 1130 
; 0000 1131 //PORTF.4   SETUP  STEROWNIK3
; 0000 1132 //PORTF.5   DRIVE  STEROWNIK3
; 0000 1133 
; 0000 1134 //sprawdz_pin0(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK3
; 0000 1135 //sprawdz_pin3(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK3
; 0000 1136 
; 0000 1137 
; 0000 1138 if(step == 0)
;	step -> Y+0
; 0000 1139 {
; 0000 113A switch(pozycjonowanie_LEFS32_300_1)
; 0000 113B     {
; 0000 113C     case 0:
; 0000 113D             PORT_F.bits.b4 = 1;      // ////A9  SETUP
; 0000 113E             PORTF = PORT_F.byte;
; 0000 113F 
; 0000 1140             if(sprawdz_pin0(PORTKK,0x75) == 1)  //BUSY
; 0000 1141                 {
; 0000 1142                 }
; 0000 1143             else
; 0000 1144                 {
; 0000 1145                 pozycjonowanie_LEFS32_300_1 = 1;
; 0000 1146                 }
; 0000 1147 
; 0000 1148     break;
; 0000 1149 
; 0000 114A     case 1:
; 0000 114B             if(sprawdz_pin0(PORTKK,0x75) == 0)
; 0000 114C                 {
; 0000 114D                 }
; 0000 114E             else
; 0000 114F                 {
; 0000 1150                 pozycjonowanie_LEFS32_300_1 = 2;
; 0000 1151                 }
; 0000 1152             if(sprawdz_pin7(PORTMM,0x77) == 1)     //alarm
; 0000 1153                    {
; 0000 1154                    komunikat_na_panel("                                                ",adr1,adr2);
; 0000 1155                    komunikat_na_panel("Przeciazenia LEFS32_1",adr1,adr2);
; 0000 1156                    }
; 0000 1157 
; 0000 1158     break;
; 0000 1159 
; 0000 115A     case 2:
; 0000 115B 
; 0000 115C             if(sprawdz_pin3(PORTKK,0x75) == 1)
; 0000 115D                 {
; 0000 115E                 }
; 0000 115F             else
; 0000 1160                 {
; 0000 1161                 pozycjonowanie_LEFS32_300_1 = 3;
; 0000 1162                 }
; 0000 1163              if(sprawdz_pin7(PORTMM,0x77) == 1)     //alarm
; 0000 1164                    {
; 0000 1165                    komunikat_na_panel("                                                ",adr1,adr2);
; 0000 1166                    komunikat_na_panel("Przeciazenia LEFS32_1",adr1,adr2);
; 0000 1167                    }
; 0000 1168 
; 0000 1169     break;
; 0000 116A 
; 0000 116B     case 3:
; 0000 116C 
; 0000 116D             if(sprawdz_pin3(PORTKK,0x75) == 0)
; 0000 116E                 {
; 0000 116F                 PORT_F.bits.b4 = 0;      // ////A9  SETUP
; 0000 1170                 PORTF = PORT_F.byte;
; 0000 1171                 pozycjonowanie_LEFS32_300_1 = 4;
; 0000 1172 
; 0000 1173                 }
; 0000 1174 
; 0000 1175     break;
; 0000 1176 
; 0000 1177     }
; 0000 1178 }
; 0000 1179 
; 0000 117A 
; 0000 117B 
; 0000 117C if(step == 1)
; 0000 117D {
; 0000 117E while(cykl < 5)
; 0000 117F {
; 0000 1180     switch(cykl)
; 0000 1181         {
; 0000 1182         case 0:
; 0000 1183 
; 0000 1184             sek2 = 0;
; 0000 1185             PORT_F.bits.b0 = 1;
; 0000 1186             PORT_F.bits.b1 = 1;         //STEP 0
; 0000 1187             PORT_F.bits.b2 = 1;
; 0000 1188             PORT_F.bits.b3 = 1;
; 0000 1189             PORTF = PORT_F.byte;
; 0000 118A             cykl = 1;
; 0000 118B 
; 0000 118C 
; 0000 118D         break;
; 0000 118E 
; 0000 118F         case 1:
; 0000 1190 
; 0000 1191             if(sek2 > 1)
; 0000 1192                 {
; 0000 1193                 PORT_F.bits.b5 = 1;
; 0000 1194                 PORTF = PORT_F.byte;
; 0000 1195                 cykl = 2;
; 0000 1196                 delay_ms(1000);
; 0000 1197                 }
; 0000 1198         break;
; 0000 1199 
; 0000 119A 
; 0000 119B         case 2:
; 0000 119C 
; 0000 119D                if(sprawdz_pin0(PORTKK,0x75) == 0)
; 0000 119E                   {
; 0000 119F                   PORT_F.bits.b5 = 0;
; 0000 11A0                   PORTF = PORT_F.byte;       //DRIVE koniec
; 0000 11A1 
; 0000 11A2                   PORT_F.bits.b0 = 0;
; 0000 11A3                   PORT_F.bits.b1 = 0;         //STEP 1 koniec
; 0000 11A4                   PORT_F.bits.b2 = 0;
; 0000 11A5                   PORT_F.bits.b3 = 0;
; 0000 11A6                   PORTF = PORT_F.byte;
; 0000 11A7 
; 0000 11A8                   delay_ms(1000);
; 0000 11A9                   cykl = 3;
; 0000 11AA                   }
; 0000 11AB 
; 0000 11AC         break;
; 0000 11AD 
; 0000 11AE         case 3:
; 0000 11AF 
; 0000 11B0                if(sprawdz_pin3(PORTKK,0x75) == 0)
; 0000 11B1                   {
; 0000 11B2                   sek2 = 0;
; 0000 11B3                   cykl = 4;
; 0000 11B4                   }
; 0000 11B5               if(sprawdz_pin7(PORTMM,0x77) == 1)     //alarm
; 0000 11B6                    {
; 0000 11B7                    komunikat_na_panel("                                                ",adr1,adr2);
; 0000 11B8                    komunikat_na_panel("Przeciazenia LEFS32_1",adr1,adr2);
; 0000 11B9                    }
; 0000 11BA 
; 0000 11BB         break;
; 0000 11BC 
; 0000 11BD 
; 0000 11BE         case 4:
; 0000 11BF 
; 0000 11C0             if(sek2 > 50)
; 0000 11C1                 {
; 0000 11C2                 cykl = 5;
; 0000 11C3                 }
; 0000 11C4         break;
; 0000 11C5 
; 0000 11C6         }
; 0000 11C7 }
; 0000 11C8 
; 0000 11C9 cykl = 0;
; 0000 11CA }
; 0000 11CB 
; 0000 11CC 
; 0000 11CD 
; 0000 11CE 
; 0000 11CF 
; 0000 11D0 if(step == 0 & pozycjonowanie_LEFS32_300_1 == 4)
; 0000 11D1     {
; 0000 11D2     pozycjonowanie_LEFS32_300_1 = 0;
; 0000 11D3     cykl = 0;
; 0000 11D4     return 1;
; 0000 11D5     }
; 0000 11D6 if(step == 1)
; 0000 11D7     return 2;
; 0000 11D8 
; 0000 11D9 
; 0000 11DA 
; 0000 11DB }
;
;
;int wypozycjonuj_LEFS32_300_2(int step)
; 0000 11DF {
; 0000 11E0 //PORTB.0   IN0  STEROWNIK4
; 0000 11E1 //PORTB.1   IN1  STEROWNIK4
; 0000 11E2 //PORTB.2   IN2  STEROWNIK4
; 0000 11E3 //PORTB.3   IN3  STEROWNIK4
; 0000 11E4 
; 0000 11E5 //PORTB.4   SETUP  STEROWNIK4
; 0000 11E6 //PORTB.5   DRIVE  STEROWNIK4
; 0000 11E7 
; 0000 11E8 //sprawdz_pin4(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK4
; 0000 11E9 //sprawdz_pin7(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK4
; 0000 11EA 
; 0000 11EB 
; 0000 11EC if(step == 0)
;	step -> Y+0
; 0000 11ED {
; 0000 11EE switch(pozycjonowanie_LEFS32_300_2)
; 0000 11EF     {
; 0000 11F0     case 0:
; 0000 11F1             PORTB.4 = 1;      // ////A9  SETUP
; 0000 11F2 
; 0000 11F3             if(sprawdz_pin4(PORTKK,0x75) == 1)  //BUSY
; 0000 11F4                 {
; 0000 11F5                 }
; 0000 11F6             else
; 0000 11F7                 pozycjonowanie_LEFS32_300_2 = 1;
; 0000 11F8 
; 0000 11F9     break;
; 0000 11FA 
; 0000 11FB     case 1:
; 0000 11FC             if(sprawdz_pin4(PORTKK,0x75) == 0)
; 0000 11FD                 {
; 0000 11FE                 }
; 0000 11FF             else
; 0000 1200                 pozycjonowanie_LEFS32_300_2 = 2;
; 0000 1201 
; 0000 1202              if(sprawdz_pin6(PORTMM,0x77) == 1)     //alarm
; 0000 1203                    {
; 0000 1204                    komunikat_na_panel("                                                ",adr1,adr2);
; 0000 1205                    komunikat_na_panel("Przeciazenia LEFS32_2",adr3,adr4);
; 0000 1206                    }
; 0000 1207 
; 0000 1208     break;
; 0000 1209 
; 0000 120A     case 2:
; 0000 120B 
; 0000 120C             if(sprawdz_pin7(PORTKK,0x75) == 1)
; 0000 120D                 {
; 0000 120E                 }
; 0000 120F             else
; 0000 1210                 pozycjonowanie_LEFS32_300_2 = 3;
; 0000 1211 
; 0000 1212             if(sprawdz_pin6(PORTMM,0x77) == 1)     //alarm
; 0000 1213                    {
; 0000 1214                    komunikat_na_panel("                                                ",adr1,adr2);
; 0000 1215                    komunikat_na_panel("Przeciazenia LEFS32_2",adr3,adr4);
; 0000 1216                    }
; 0000 1217 
; 0000 1218     break;
; 0000 1219 
; 0000 121A     case 3:
; 0000 121B 
; 0000 121C             if(sprawdz_pin7(PORTKK,0x75) == 0)
; 0000 121D                 {
; 0000 121E                 PORTB.4 = 0;      // ////A9  SETUP
; 0000 121F 
; 0000 1220                 pozycjonowanie_LEFS32_300_2 = 4;
; 0000 1221                 }
; 0000 1222 
; 0000 1223     break;
; 0000 1224 
; 0000 1225     }
; 0000 1226 }
; 0000 1227 
; 0000 1228 if(step == 1)
; 0000 1229 {
; 0000 122A while(cykl < 5)
; 0000 122B {
; 0000 122C     switch(cykl)
; 0000 122D         {
; 0000 122E         case 0:
; 0000 122F 
; 0000 1230             sek4 = 0;
; 0000 1231             PORTB.0 = 1;    //STEP 0
; 0000 1232             PORTB.1 = 1;
; 0000 1233             PORTB.2 = 1;
; 0000 1234             PORTB.3 = 1;
; 0000 1235 
; 0000 1236             cykl = 1;
; 0000 1237 
; 0000 1238 
; 0000 1239         break;
; 0000 123A 
; 0000 123B         case 1:
; 0000 123C 
; 0000 123D             if(sek4 > 1)
; 0000 123E                 {
; 0000 123F                 PORTB.5 = 1;
; 0000 1240                 cykl = 2;
; 0000 1241                 delay_ms(1000);
; 0000 1242                 }
; 0000 1243         break;
; 0000 1244 
; 0000 1245 
; 0000 1246         case 2:
; 0000 1247 
; 0000 1248                if(sprawdz_pin4(PORTKK,0x75) == 0)
; 0000 1249                   {
; 0000 124A                   PORTB.5 = 0;
; 0000 124B                       //DRIVE koniec
; 0000 124C 
; 0000 124D                   PORTB.0 = 0;    //STEP 0
; 0000 124E                   PORTB.1 = 0;
; 0000 124F                   PORTB.2 = 0;
; 0000 1250                   PORTB.3 = 0;
; 0000 1251 
; 0000 1252 
; 0000 1253                   delay_ms(1000);
; 0000 1254                   cykl = 3;
; 0000 1255                   }
; 0000 1256 
; 0000 1257         break;
; 0000 1258 
; 0000 1259         case 3:
; 0000 125A 
; 0000 125B                if(sprawdz_pin7(PORTKK,0x75) == 0)
; 0000 125C                   {
; 0000 125D                   sek4 = 0;
; 0000 125E                   cykl = 4;
; 0000 125F                   }
; 0000 1260                if(sprawdz_pin6(PORTMM,0x77) == 1)     //alarm
; 0000 1261                    {
; 0000 1262                    komunikat_na_panel("                                                ",adr1,adr2);
; 0000 1263                    komunikat_na_panel("Przeciazenia LEFS32_2",adr3,adr4);
; 0000 1264                    }
; 0000 1265 
; 0000 1266 
; 0000 1267         break;
; 0000 1268 
; 0000 1269 
; 0000 126A         case 4:
; 0000 126B 
; 0000 126C             if(sek4 > 50)
; 0000 126D                 cykl = 5;
; 0000 126E         break;
; 0000 126F 
; 0000 1270         }
; 0000 1271 }
; 0000 1272 
; 0000 1273 cykl = 0;
; 0000 1274 }
; 0000 1275 
; 0000 1276 if(step == 0 & pozycjonowanie_LEFS32_300_2 == 4)
; 0000 1277     {
; 0000 1278     pozycjonowanie_LEFS32_300_2 = 0;
; 0000 1279     cykl = 0;
; 0000 127A     return 1;
; 0000 127B     }
; 0000 127C if(step == 1)
; 0000 127D     return 2;
; 0000 127E 
; 0000 127F }
;
;
;
;
;
;
;int wypozycjonuj_LEFS40_1200_2_i_300_2()
; 0000 1287 {
; 0000 1288 //PORTC.0   IN0  STEROWNIK2
; 0000 1289 //PORTC.1   IN1  STEROWNIK2
; 0000 128A //PORTC.2   IN2  STEROWNIK2
; 0000 128B //PORTC.3   IN3  STEROWNIK2
; 0000 128C //PORTC.4   IN4  STEROWNIK2
; 0000 128D //PORTC.5   IN5  STEROWNIK2
; 0000 128E //PORTC.6   IN6  STEROWNIK2
; 0000 128F //PORTC.7   IN7  STEROWNIK2
; 0000 1290 
; 0000 1291 //PORTD.5  SETUP   STEROWNIK2
; 0000 1292 //PORTD.6  DRIVE   STEROWNIK2
; 0000 1293 
; 0000 1294 //sprawdz_pin0(PORTLL,0x71)  BUSY   STEROWNIK2
; 0000 1295 //sprawdz_pin3(PORTLL,0x71)  INP    STEROWNIK2
; 0000 1296 
; 0000 1297 PORTD.5 = 1;    //SETUP
; 0000 1298 
; 0000 1299 delay_ms(50);
; 0000 129A 
; 0000 129B while(sprawdz_pin0(PORTLL,0x71) == 1)  //kraze tu poki nie wywali busy
; 0000 129C         {
; 0000 129D 
; 0000 129E                    if(sprawdz_pin5(PORTLL,0x71) == 1)     //alarm
; 0000 129F                    {
; 0000 12A0                    komunikat_na_panel("                                                ",adr1,adr2);
; 0000 12A1                    komunikat_na_panel("Przeciazenia LEFS_XY_2",adr3,adr4);
; 0000 12A2                    }
; 0000 12A3 
; 0000 12A4         }
; 0000 12A5 
; 0000 12A6 delay_ms(50);
; 0000 12A7 
; 0000 12A8 while(sprawdz_pin0(PORTLL,0x71) == 0)  //wywala busy
; 0000 12A9         {
; 0000 12AA 
; 0000 12AB                    if(sprawdz_pin5(PORTLL,0x71) == 1)     //alarm
; 0000 12AC                    {
; 0000 12AD                    komunikat_na_panel("                                                ",adr1,adr2);
; 0000 12AE                    komunikat_na_panel("Przeciazenia LEFS_XY_2",adr3,adr4);
; 0000 12AF                    }
; 0000 12B0         }
; 0000 12B1 
; 0000 12B2 delay_ms(50);
; 0000 12B3 
; 0000 12B4 while(sprawdz_pin3(PORTLL,0x71) == 1)  //kraze tu dopoki nie wywali INP
; 0000 12B5         {
; 0000 12B6         }
; 0000 12B7 
; 0000 12B8 delay_ms(50);
; 0000 12B9 
; 0000 12BA if(sprawdz_pin3(PORTLL,0x71) == 0)  //wywala INP
; 0000 12BB         {
; 0000 12BC         PORTD.5 = 0;
; 0000 12BD         putchar(90);  //5A
; 0000 12BE         putchar(165); //A5
; 0000 12BF         putchar(3);//03  //znak dzwiekowy ze jestem
; 0000 12C0         putchar(128);  //80
; 0000 12C1         putchar(2);    //02
; 0000 12C2         putchar(16);   //10
; 0000 12C3         }
; 0000 12C4 else
; 0000 12C5     {
; 0000 12C6         putchar(90);  //5A
; 0000 12C7         putchar(165); //A5
; 0000 12C8         putchar(3);//03  //znak dzwiekowy ze jestem
; 0000 12C9         putchar(128);  //80
; 0000 12CA         putchar(2);    //02
; 0000 12CB         putchar(16);   //10
; 0000 12CC 
; 0000 12CD         delay_ms(1000);     //wywalenie bledu
; 0000 12CE         delay_ms(1000);
; 0000 12CF 
; 0000 12D0         putchar(90);  //5A
; 0000 12D1         putchar(165); //A5
; 0000 12D2         putchar(3);//03  //znak dzwiekowy ze jestem
; 0000 12D3         putchar(128);  //80
; 0000 12D4         putchar(2);    //02
; 0000 12D5         putchar(16);   //10
; 0000 12D6 
; 0000 12D7     }
; 0000 12D8 
; 0000 12D9 delay_ms(1000);
; 0000 12DA 
; 0000 12DB while(cykl < 5)
; 0000 12DC {
; 0000 12DD     switch(cykl)
; 0000 12DE         {
; 0000 12DF         case 0:
; 0000 12E0 
; 0000 12E1             PORTC = 0xFF;   //STEP 0
; 0000 12E2             cykl = 1;
; 0000 12E3 
; 0000 12E4         break;
; 0000 12E5 
; 0000 12E6         case 1:
; 0000 12E7 
; 0000 12E8             if(sek3 > 1)
; 0000 12E9                 {
; 0000 12EA                 PORTD.6 = 1;  //DRIVE
; 0000 12EB                 cykl = 2;
; 0000 12EC                 }
; 0000 12ED         break;
; 0000 12EE 
; 0000 12EF 
; 0000 12F0         case 2:
; 0000 12F1 
; 0000 12F2                if(sprawdz_pin0(PORTLL,0x71) == 0)
; 0000 12F3                   {
; 0000 12F4                   PORTD.6 = 0;
; 0000 12F5                   PORTC = 0x00;        //STEP 1 koniec
; 0000 12F6                   cykl = 3;
; 0000 12F7                   }
; 0000 12F8 
; 0000 12F9         break;
; 0000 12FA 
; 0000 12FB         case 3:
; 0000 12FC 
; 0000 12FD                if(sprawdz_pin3(PORTLL,0x71) == 0)
; 0000 12FE                   {
; 0000 12FF                   sek3 = 0;
; 0000 1300                   cykl = 4;
; 0000 1301                   }
; 0000 1302 
; 0000 1303                    if(sprawdz_pin5(PORTLL,0x71) == 1)     //alarm
; 0000 1304                    {
; 0000 1305                    komunikat_na_panel("                                                ",adr1,adr2);
; 0000 1306                    komunikat_na_panel("Przeciazenia LEFS_XY_2",adr3,adr4);
; 0000 1307                    }
; 0000 1308 
; 0000 1309 
; 0000 130A         break;
; 0000 130B 
; 0000 130C 
; 0000 130D         case 4:
; 0000 130E 
; 0000 130F             if(sek3 > 50)
; 0000 1310                 cykl = 5;
; 0000 1311         break;
; 0000 1312 
; 0000 1313         }
; 0000 1314 }
; 0000 1315 
; 0000 1316 cykl = 0;
; 0000 1317 return 1;
; 0000 1318 }
;
;
;
;
;int wypozycjonuj_LEFS40_1200_1_i_300_1()
; 0000 131E {
; 0000 131F //chyba nie wpiete A7
; 0000 1320 
; 0000 1321 //PORTA.0   IN0  STEROWNIK1
; 0000 1322 //PORTA.1   IN1  STEROWNIK1
; 0000 1323 //PORTA.2   IN2  STEROWNIK1
; 0000 1324 //PORTA.3   IN3  STEROWNIK1
; 0000 1325 //PORTA.4   IN4  STEROWNIK1
; 0000 1326 //PORTA.5   IN5  STEROWNIK1
; 0000 1327 //PORTA.6   IN6  STEROWNIK1
; 0000 1328 //PORTA.7   IN7  STEROWNIK1
; 0000 1329 
; 0000 132A //PORTD.2  SETUP   STEROWNIK1
; 0000 132B //PORTD.3  DRIVE   STEROWNIK1
; 0000 132C 
; 0000 132D //sprawdz_pin0(PORTJJ,0x79)  BUSY   STEROWNIK1
; 0000 132E //sprawdz_pin3(PORTJJ,0x79)  INP    STEROWNIK1
; 0000 132F 
; 0000 1330 PORTD.2 = 1;    //SETUP
; 0000 1331 
; 0000 1332 delay_ms(50);
; 0000 1333 
; 0000 1334 while(sprawdz_pin0(PORTJJ,0x79) == 1)  //kraze tu poki nie wywali busy
; 0000 1335         {
; 0000 1336             if(sprawdz_pin5(PORTJJ,0x79) == 1)     //alarm
; 0000 1337                    {
; 0000 1338                    komunikat_na_panel("                                                ",adr1,adr2);
; 0000 1339                    komunikat_na_panel("Przeciazenia LEFS_XY_1",adr1,adr2);
; 0000 133A                    }
; 0000 133B         }
; 0000 133C 
; 0000 133D delay_ms(50);
; 0000 133E 
; 0000 133F while(sprawdz_pin0(PORTJJ,0x79) == 0)  //wywala busy
; 0000 1340         {
; 0000 1341             if(sprawdz_pin5(PORTJJ,0x79) == 1)     //alarm
; 0000 1342                    {
; 0000 1343                    komunikat_na_panel("                                                ",adr1,adr2);
; 0000 1344                    komunikat_na_panel("Przeciazenia LEFS_XY_1",adr1,adr2);
; 0000 1345                    }
; 0000 1346 
; 0000 1347         }
; 0000 1348 
; 0000 1349 delay_ms(50);
; 0000 134A 
; 0000 134B while(sprawdz_pin3(PORTJJ,0x79) == 1)  //kraze tu dopoki nie wywali INP
; 0000 134C         {
; 0000 134D         }
; 0000 134E 
; 0000 134F delay_ms(50);
; 0000 1350 
; 0000 1351 if(sprawdz_pin3(PORTJJ,0x79) == 0)  //wywala INP
; 0000 1352         {
; 0000 1353         PORTD.2 = 0;
; 0000 1354         putchar(90);  //5A
; 0000 1355         putchar(165); //A5
; 0000 1356         putchar(3);//03  //znak dzwiekowy ze jestem
; 0000 1357         putchar(128);  //80
; 0000 1358         putchar(2);    //02
; 0000 1359         putchar(16);   //10
; 0000 135A         }
; 0000 135B else
; 0000 135C     {
; 0000 135D         putchar(90);  //5A
; 0000 135E         putchar(165); //A5
; 0000 135F         putchar(3);//03  //znak dzwiekowy ze jestem
; 0000 1360         putchar(128);  //80
; 0000 1361         putchar(2);    //02
; 0000 1362         putchar(16);   //10
; 0000 1363 
; 0000 1364         delay_ms(1000);     //wywalenie bledu
; 0000 1365         delay_ms(1000);
; 0000 1366 
; 0000 1367         putchar(90);  //5A
; 0000 1368         putchar(165); //A5
; 0000 1369         putchar(3);//03  //znak dzwiekowy ze jestem
; 0000 136A         putchar(128);  //80
; 0000 136B         putchar(2);    //02
; 0000 136C         putchar(16);   //10
; 0000 136D 
; 0000 136E     }
; 0000 136F 
; 0000 1370 delay_ms(1000);
; 0000 1371 
; 0000 1372 while(cykl < 5)
; 0000 1373 {
; 0000 1374     switch(cykl)
; 0000 1375         {
; 0000 1376         case 0:
; 0000 1377 
; 0000 1378             PORTA = 0xFF;   //STEP 0
; 0000 1379             cykl = 1;
; 0000 137A 
; 0000 137B         break;
; 0000 137C 
; 0000 137D         case 1:
; 0000 137E 
; 0000 137F             if(sek1 > 1)
; 0000 1380                 {
; 0000 1381                 PORTD.3 = 1;  //DRIVE
; 0000 1382                 cykl = 2;
; 0000 1383                 }
; 0000 1384         break;
; 0000 1385 
; 0000 1386 
; 0000 1387         case 2:
; 0000 1388 
; 0000 1389                if(sprawdz_pin0(PORTJJ,0x79) == 0)
; 0000 138A                   {
; 0000 138B                   PORTD.3 = 0;
; 0000 138C                   PORTA = 0x00;        //STEP 1 koniec
; 0000 138D                   cykl = 3;
; 0000 138E                   }
; 0000 138F 
; 0000 1390         break;
; 0000 1391 
; 0000 1392         case 3:
; 0000 1393 
; 0000 1394                if(sprawdz_pin3(PORTJJ,0x79) == 0)
; 0000 1395                   {
; 0000 1396                   sek1 = 0;
; 0000 1397                   cykl = 4;
; 0000 1398                   }
; 0000 1399 
; 0000 139A                if(sprawdz_pin5(PORTJJ,0x79) == 1)     //alarm
; 0000 139B                    {
; 0000 139C                    komunikat_na_panel("                                                ",adr1,adr2);
; 0000 139D                    komunikat_na_panel("Przeciazenia LEFS_XY_1",adr1,adr2);
; 0000 139E                    }
; 0000 139F 
; 0000 13A0 
; 0000 13A1         break;
; 0000 13A2 
; 0000 13A3 
; 0000 13A4         case 4:
; 0000 13A5 
; 0000 13A6             if(sek1 > 50)
; 0000 13A7                 cykl = 5;
; 0000 13A8         break;
; 0000 13A9 
; 0000 13AA         }
; 0000 13AB }
; 0000 13AC 
; 0000 13AD cykl = 0;
; 0000 13AE return 1;
; 0000 13AF }
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
; 0000 13BA {
; 0000 13BB //if(aaa == 0)
; 0000 13BC //        {
; 0000 13BD //        aaa = wypozycjonuj_LEFS40_1200_1_i_300_1();
; 0000 13BE //        }
; 0000 13BF if(bbb == 0)
; 0000 13C0         {
; 0000 13C1         bbb = wypozycjonuj_LEFS32_300_1(0);
; 0000 13C2         }
; 0000 13C3 if(bbb == 1)
; 0000 13C4         {
; 0000 13C5         bbb = wypozycjonuj_LEFS32_300_1(1);
; 0000 13C6        }
; 0000 13C7 
; 0000 13C8 
; 0000 13C9 //if(ccc == 0)
; 0000 13CA //        {
; 0000 13CB //        ccc = wypozycjonuj_LEFS40_1200_2_i_300_2();
; 0000 13CC //        }
; 0000 13CD //if(ddd == 0)
; 0000 13CE //        {
; 0000 13CF //        ddd = wypozycjonuj_LEFS32_300_2(0);
; 0000 13D0 //       }
; 0000 13D1 //if(ddd == 1)
; 0000 13D2 //        {
; 0000 13D3 //        ddd = wypozycjonuj_LEFS32_300_2(1);
; 0000 13D4 //        }
; 0000 13D5 
; 0000 13D6 
; 0000 13D7 
; 0000 13D8 
; 0000 13D9 
; 0000 13DA 
; 0000 13DB    /*
; 0000 13DC 
; 0000 13DD     if(ccc == 1 & bbb == 1)
; 0000 13DE         ccc = wypozycjonuj_NL3_upgrade(1);
; 0000 13DF 
; 0000 13E0     if(bbb == 1 & ccc == 2)
; 0000 13E1         bbb = wypozycjonuj_NL2_upgrade(1);
; 0000 13E2 
; 0000 13E3 
; 0000 13E4     if(aaa == 1 & bbb == 2 & ccc == 2)
; 0000 13E5         {
; 0000 13E6         start = 1;
; 0000 13E7         }
; 0000 13E8 
; 0000 13E9     */
; 0000 13EA 
; 0000 13EB //    if(aaa == 1 & bbb == 2 & ccc == 2 & ddd == 2)
; 0000 13EC //        start = 1;
; 0000 13ED 
; 0000 13EE 
; 0000 13EF }
;
;
;
;
;void przerzucanie_dociskow()
; 0000 13F5 {
_przerzucanie_dociskow:
; 0000 13F6    if(sprawdz_pin6(PORTLL,0x71) == 0 & sprawdz_pin7(PORTLL,0x71) == 0 & czekaj_az_puszcze == 0)
	CALL SUBOPT_0x84
	CALL _sprawdz_pin6
	LDI  R26,LOW(0)
	CALL __EQB12
	PUSH R30
	CALL SUBOPT_0x84
	CALL _sprawdz_pin7
	LDI  R26,LOW(0)
	CALL __EQB12
	POP  R26
	CALL SUBOPT_0x8A
	CALL SUBOPT_0x8B
	AND  R30,R0
	BREQ _0x214
; 0000 13F7            {
; 0000 13F8            czekaj_az_puszcze = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _czekaj_az_puszcze,R30
	STS  _czekaj_az_puszcze+1,R31
; 0000 13F9            //PORTB.6 = 1;
; 0000 13FA            }
; 0000 13FB        if(sprawdz_pin6(PORTLL,0x71) == 1 & sprawdz_pin7(PORTLL,0x71) == 1 & czekaj_az_puszcze == 1)
_0x214:
	CALL SUBOPT_0x84
	CALL SUBOPT_0x87
	PUSH R30
	CALL SUBOPT_0x84
	CALL SUBOPT_0x86
	POP  R26
	CALL SUBOPT_0x8A
	CALL SUBOPT_0x7A
	AND  R30,R0
	BREQ _0x215
; 0000 13FC            {
; 0000 13FD            czekaj_az_puszcze = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _czekaj_az_puszcze,R30
	STS  _czekaj_az_puszcze+1,R31
; 0000 13FE            //PORTB.6 = 0;
; 0000 13FF            }
; 0000 1400 
; 0000 1401        if(czekaj_az_puszcze == 2 & PORTE.6 == 1)
_0x215:
	CALL SUBOPT_0x8C
	LDI  R30,LOW(1)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x216
; 0000 1402             {
; 0000 1403             PORTE.6 = 0;
	CBI  0x3,6
; 0000 1404             czekaj_az_puszcze = 0;
	CALL SUBOPT_0x8D
; 0000 1405             delay_ms(100);
; 0000 1406             }
; 0000 1407 
; 0000 1408        if(czekaj_az_puszcze == 2 & PORTE.6 == 0)
_0x216:
	CALL SUBOPT_0x8C
	LDI  R30,LOW(0)
	CALL __EQB12
	AND  R30,R0
	BREQ _0x219
; 0000 1409            {
; 0000 140A             PORTE.6 = 1;
	SBI  0x3,6
; 0000 140B             czekaj_az_puszcze = 0;
	CALL SUBOPT_0x8D
; 0000 140C             delay_ms(100);
; 0000 140D            }
; 0000 140E 
; 0000 140F }
_0x219:
	RET
;
;void ostateczny_wybor_zacisku()
; 0000 1412 {
_ostateczny_wybor_zacisku:
; 0000 1413 int rzad;
; 0000 1414 
; 0000 1415   if(sek11 > 60) //co 1s sekunde sprawdzam   //jak co 40 to sie wywala
	ST   -Y,R17
	ST   -Y,R16
;	rzad -> R16,R17
	LDS  R26,_sek11
	LDS  R27,_sek11+1
	LDS  R24,_sek11+2
	LDS  R25,_sek11+3
	__CPD2N 0x3D
	BRGE PC+3
	JMP _0x21C
; 0000 1416         {
; 0000 1417        sek11 = 0;
	CALL SUBOPT_0x8E
; 0000 1418        if(odczytalem_zacisk < il_prob_odczytu &
; 0000 1419                                            (sprawdz_pin0(PORTHH,0x73) == 1 |
; 0000 141A                                             sprawdz_pin1(PORTHH,0x73) == 1 |
; 0000 141B                                             sprawdz_pin2(PORTHH,0x73) == 1 |
; 0000 141C                                             sprawdz_pin3(PORTHH,0x73) == 1 |
; 0000 141D                                             sprawdz_pin4(PORTHH,0x73) == 1 |
; 0000 141E                                             sprawdz_pin5(PORTHH,0x73) == 1 |
; 0000 141F                                             sprawdz_pin6(PORTHH,0x73) == 1 |
; 0000 1420                                             sprawdz_pin7(PORTHH,0x73) == 1))
	MOVW R30,R10
	MOVW R26,R8
	CALL __LTW12
	PUSH R30
	CALL SUBOPT_0x33
	CALL SUBOPT_0x81
	PUSH R30
	CALL SUBOPT_0x33
	CALL SUBOPT_0x82
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x33
	CALL _sprawdz_pin2
	LDI  R26,LOW(1)
	CALL __EQB12
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x33
	CALL SUBOPT_0x83
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x33
	CALL _sprawdz_pin4
	LDI  R26,LOW(1)
	CALL __EQB12
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x33
	CALL SUBOPT_0x88
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x33
	CALL SUBOPT_0x87
	POP  R26
	OR   R30,R26
	PUSH R30
	CALL SUBOPT_0x33
	CALL SUBOPT_0x86
	POP  R26
	OR   R30,R26
	POP  R26
	AND  R30,R26
	BREQ _0x21D
; 0000 1421         {
; 0000 1422         odczytalem_zacisk++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 1423         }
; 0000 1424         }
_0x21D:
; 0000 1425 
; 0000 1426 if(odczytalem_zacisk == il_prob_odczytu)
_0x21C:
	__CPWRR 10,11,8,9
	BRNE _0x21E
; 0000 1427         {
; 0000 1428         //PORTB = 0xFF;
; 0000 1429         rzad = odczyt_wybranego_zacisku();
	CALL _odczyt_wybranego_zacisku
	MOVW R16,R30
; 0000 142A         //sek10 = 0;
; 0000 142B         sek11 = 0;    //nowe
	CALL SUBOPT_0x8E
; 0000 142C         odczytalem_zacisk++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 142D         if(rzad == 1)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x21F
; 0000 142E             wartosc_parametru_panelu(2,32,128);
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x8F
; 0000 142F         if(rzad == 2)
_0x21F:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x220
; 0000 1430             wartosc_parametru_panelu(1,32,128);
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x8F
; 0000 1431 
; 0000 1432         }                                     //& sek10 > 1                //3s po odczytaniu dopiero sprawdzam port
_0x220:
; 0000 1433 if((odczytalem_zacisk == il_prob_odczytu + 1))        //183
_0x21E:
	MOVW R30,R10
	ADIW R30,1
	CP   R30,R8
	CPC  R31,R9
	BRNE _0x221
; 0000 1434         {
; 0000 1435         odczytalem_zacisk = 0;
	CLR  R8
	CLR  R9
; 0000 1436         }
; 0000 1437 }
_0x221:
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;
;
;int sterownik_1_praca(int PORT)
; 0000 143C {
_sterownik_1_praca:
; 0000 143D //PORTA.0   IN0  STEROWNIK1
; 0000 143E //PORTA.1   IN1  STEROWNIK1
; 0000 143F //PORTA.2   IN2  STEROWNIK1
; 0000 1440 //PORTA.3   IN3  STEROWNIK1
; 0000 1441 //PORTA.4   IN4  STEROWNIK1
; 0000 1442 //PORTA.5   IN5  STEROWNIK1
; 0000 1443 //PORTA.6   IN6  STEROWNIK1
; 0000 1444 //PORTA.7   IN7  STEROWNIK1
; 0000 1445 //PORTD.4   IN8 STEROWNIK1
; 0000 1446 
; 0000 1447 //PORTD.2  SETUP   STEROWNIK1
; 0000 1448 //PORTD.3  DRIVE   STEROWNIK1
; 0000 1449 
; 0000 144A //sprawdz_pin0(PORTJJ,0x79)  BUSY   STEROWNIK1
; 0000 144B //sprawdz_pin3(PORTJJ,0x79)  INP    STEROWNIK1
; 0000 144C 
; 0000 144D if(sprawdz_pin5(PORTJJ,0x79) == 1)
;	PORT -> Y+0
	CALL SUBOPT_0x30
	CALL _sprawdz_pin5
	CPI  R30,LOW(0x1)
	BRNE _0x222
; 0000 144E     {
; 0000 144F     PORTD.7 = 1;
	SBI  0x12,7
; 0000 1450     PORTE.2 = 0;
	CBI  0x3,2
; 0000 1451     PORTE.3 = 0;  //szlifierki stop
	CBI  0x3,3
; 0000 1452     }
; 0000 1453 
; 0000 1454 switch(cykl_sterownik_1)
_0x222:
	LDS  R30,_cykl_sterownik_1
	LDS  R31,_cykl_sterownik_1+1
; 0000 1455         {
; 0000 1456         case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x22C
; 0000 1457 
; 0000 1458             sek1 = 0;
	CALL SUBOPT_0x90
; 0000 1459             PORT_STER1.byte = PORT;
	LD   R30,Y
	STS  _PORT_STER1,R30
; 0000 145A             PORTA.0 = PORT_STER1.bits.b0;
	ANDI R30,LOW(0x1)
	BRNE _0x22D
	CBI  0x1B,0
	RJMP _0x22E
_0x22D:
	SBI  0x1B,0
_0x22E:
; 0000 145B             PORTA.1 = PORT_STER1.bits.b1;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x2)
	BRNE _0x22F
	CBI  0x1B,1
	RJMP _0x230
_0x22F:
	SBI  0x1B,1
_0x230:
; 0000 145C             PORTA.2 = PORT_STER1.bits.b2;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x4)
	BRNE _0x231
	CBI  0x1B,2
	RJMP _0x232
_0x231:
	SBI  0x1B,2
_0x232:
; 0000 145D             PORTA.3 = PORT_STER1.bits.b3;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x8)
	BRNE _0x233
	CBI  0x1B,3
	RJMP _0x234
_0x233:
	SBI  0x1B,3
_0x234:
; 0000 145E             PORTA.4 = PORT_STER1.bits.b4;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x10)
	BRNE _0x235
	CBI  0x1B,4
	RJMP _0x236
_0x235:
	SBI  0x1B,4
_0x236:
; 0000 145F             PORTA.5 = PORT_STER1.bits.b5;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x20)
	BRNE _0x237
	CBI  0x1B,5
	RJMP _0x238
_0x237:
	SBI  0x1B,5
_0x238:
; 0000 1460             PORTA.6 = PORT_STER1.bits.b6;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x40)
	BRNE _0x239
	CBI  0x1B,6
	RJMP _0x23A
_0x239:
	SBI  0x1B,6
_0x23A:
; 0000 1461             PORTA.7 = PORT_STER1.bits.b7;
	LDS  R30,_PORT_STER1
	ANDI R30,LOW(0x80)
	BRNE _0x23B
	CBI  0x1B,7
	RJMP _0x23C
_0x23B:
	SBI  0x1B,7
_0x23C:
; 0000 1462 
; 0000 1463             if(PORT > 0x0FF)
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x23D
; 0000 1464                 PORTD.4 = 1;
	SBI  0x12,4
; 0000 1465 
; 0000 1466 
; 0000 1467 
; 0000 1468             cykl_sterownik_1 = 1;
_0x23D:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x4A5
; 0000 1469 
; 0000 146A         break;
; 0000 146B 
; 0000 146C         case 1:
_0x22C:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x240
; 0000 146D 
; 0000 146E             if(sek1 > 1)
	LDS  R26,_sek1
	LDS  R27,_sek1+1
	LDS  R24,_sek1+2
	LDS  R25,_sek1+3
	CALL SUBOPT_0x91
	BRLT _0x241
; 0000 146F                 {
; 0000 1470 
; 0000 1471                 PORTD.3 = 1;
	SBI  0x12,3
; 0000 1472                 cykl_sterownik_1 = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x92
; 0000 1473                 }
; 0000 1474         break;
_0x241:
	RJMP _0x22B
; 0000 1475 
; 0000 1476 
; 0000 1477         case 2:
_0x240:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x244
; 0000 1478 
; 0000 1479                if(sprawdz_pin0(PORTJJ,0x79) == 0)     //busy
	CALL SUBOPT_0x30
	CALL _sprawdz_pin0
	CPI  R30,0
	BRNE _0x245
; 0000 147A                   {
; 0000 147B 
; 0000 147C                   PORTD.3 = 0;
	CBI  0x12,3
; 0000 147D                   PORTA = 0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 147E                   PORTD.4 = 0;
	CBI  0x12,4
; 0000 147F                   sek1 = 0;
	CALL SUBOPT_0x90
; 0000 1480                   cykl_sterownik_1 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x92
; 0000 1481                   }
; 0000 1482 
; 0000 1483         break;
_0x245:
	RJMP _0x22B
; 0000 1484 
; 0000 1485         case 3:
_0x244:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x24A
; 0000 1486 
; 0000 1487                if(sprawdz_pin3(PORTJJ,0x79) == 0)
	CALL SUBOPT_0x30
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x24B
; 0000 1488                   {
; 0000 1489 
; 0000 148A                   sek1 = 0;
	CALL SUBOPT_0x90
; 0000 148B                   cykl_sterownik_1 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x92
; 0000 148C                   }
; 0000 148D 
; 0000 148E 
; 0000 148F         break;
_0x24B:
	RJMP _0x22B
; 0000 1490 
; 0000 1491 
; 0000 1492         case 4:
_0x24A:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x22B
; 0000 1493 
; 0000 1494             if(sprawdz_pin0(PORTJJ,0x79) == 1)
	CALL SUBOPT_0x30
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BRNE _0x24D
; 0000 1495                 {
; 0000 1496 
; 0000 1497                 cykl_sterownik_1 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
_0x4A5:
	STS  _cykl_sterownik_1,R30
	STS  _cykl_sterownik_1+1,R31
; 0000 1498                 }
; 0000 1499         break;
_0x24D:
; 0000 149A 
; 0000 149B         }
_0x22B:
; 0000 149C 
; 0000 149D return cykl_sterownik_1;
	LDS  R30,_cykl_sterownik_1
	LDS  R31,_cykl_sterownik_1+1
	RJMP _0x20A0001
; 0000 149E }
;
;
;int sterownik_2_praca(int PORT)
; 0000 14A2 {
_sterownik_2_praca:
; 0000 14A3 //PORTC.0   IN0  STEROWNIK2
; 0000 14A4 //PORTC.1   IN1  STEROWNIK2
; 0000 14A5 //PORTC.2   IN2  STEROWNIK2
; 0000 14A6 //PORTC.3   IN3  STEROWNIK2
; 0000 14A7 //PORTC.4   IN4  STEROWNIK2
; 0000 14A8 //PORTC.5   IN5  STEROWNIK2
; 0000 14A9 //PORTC.6   IN6  STEROWNIK2
; 0000 14AA //PORTC.7   IN7  STEROWNIK2
; 0000 14AB //PORTD.5   IN8 STEROWNIK2
; 0000 14AC 
; 0000 14AD 
; 0000 14AE //PORTD.5  SETUP   STEROWNIK2
; 0000 14AF //PORTD.6  DRIVE   STEROWNIK2
; 0000 14B0 
; 0000 14B1 //sprawdz_pin0(PORTLL,0x71)  BUSY   STEROWNIK2
; 0000 14B2 //sprawdz_pin3(PORTLL,0x71)  INP    STEROWNIK2
; 0000 14B3 
; 0000 14B4  if(sprawdz_pin5(PORTLL,0x71) == 1)
;	PORT -> Y+0
	CALL SUBOPT_0x84
	CALL _sprawdz_pin5
	CPI  R30,LOW(0x1)
	BRNE _0x24E
; 0000 14B5     {
; 0000 14B6     PORTD.7 = 1;
	SBI  0x12,7
; 0000 14B7     PORTE.2 = 0;
	CBI  0x3,2
; 0000 14B8     PORTE.3 = 0;  //szlifierki stop
	CBI  0x3,3
; 0000 14B9     }
; 0000 14BA 
; 0000 14BB switch(cykl_sterownik_2)
_0x24E:
	LDS  R30,_cykl_sterownik_2
	LDS  R31,_cykl_sterownik_2+1
; 0000 14BC         {
; 0000 14BD         case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x258
; 0000 14BE 
; 0000 14BF             sek3 = 0;
	CALL SUBOPT_0x93
; 0000 14C0             PORT_STER2.byte = PORT;
	LD   R30,Y
	STS  _PORT_STER2,R30
; 0000 14C1             PORTC.0 = PORT_STER2.bits.b0;
	ANDI R30,LOW(0x1)
	BRNE _0x259
	CBI  0x15,0
	RJMP _0x25A
_0x259:
	SBI  0x15,0
_0x25A:
; 0000 14C2             PORTC.1 = PORT_STER2.bits.b1;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x2)
	BRNE _0x25B
	CBI  0x15,1
	RJMP _0x25C
_0x25B:
	SBI  0x15,1
_0x25C:
; 0000 14C3             PORTC.2 = PORT_STER2.bits.b2;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x4)
	BRNE _0x25D
	CBI  0x15,2
	RJMP _0x25E
_0x25D:
	SBI  0x15,2
_0x25E:
; 0000 14C4             PORTC.3 = PORT_STER2.bits.b3;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x8)
	BRNE _0x25F
	CBI  0x15,3
	RJMP _0x260
_0x25F:
	SBI  0x15,3
_0x260:
; 0000 14C5             PORTC.4 = PORT_STER2.bits.b4;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x10)
	BRNE _0x261
	CBI  0x15,4
	RJMP _0x262
_0x261:
	SBI  0x15,4
_0x262:
; 0000 14C6             PORTC.5 = PORT_STER2.bits.b5;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x20)
	BRNE _0x263
	CBI  0x15,5
	RJMP _0x264
_0x263:
	SBI  0x15,5
_0x264:
; 0000 14C7             PORTC.6 = PORT_STER2.bits.b6;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x40)
	BRNE _0x265
	CBI  0x15,6
	RJMP _0x266
_0x265:
	SBI  0x15,6
_0x266:
; 0000 14C8             PORTC.7 = PORT_STER2.bits.b7;
	LDS  R30,_PORT_STER2
	ANDI R30,LOW(0x80)
	BRNE _0x267
	CBI  0x15,7
	RJMP _0x268
_0x267:
	SBI  0x15,7
_0x268:
; 0000 14C9             if(PORT > 0x0FF)
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x269
; 0000 14CA                 PORTD.5 = 1;
	SBI  0x12,5
; 0000 14CB 
; 0000 14CC 
; 0000 14CD             cykl_sterownik_2 = 1;
_0x269:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x4A6
; 0000 14CE 
; 0000 14CF 
; 0000 14D0         break;
; 0000 14D1 
; 0000 14D2         case 1:
_0x258:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x26C
; 0000 14D3 
; 0000 14D4             if(sek3 > 1)
	LDS  R26,_sek3
	LDS  R27,_sek3+1
	LDS  R24,_sek3+2
	LDS  R25,_sek3+3
	CALL SUBOPT_0x91
	BRLT _0x26D
; 0000 14D5                 {
; 0000 14D6                 PORTD.6 = 1;
	SBI  0x12,6
; 0000 14D7                 cykl_sterownik_2 = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x94
; 0000 14D8                 }
; 0000 14D9         break;
_0x26D:
	RJMP _0x257
; 0000 14DA 
; 0000 14DB 
; 0000 14DC         case 2:
_0x26C:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x270
; 0000 14DD 
; 0000 14DE                if(sprawdz_pin0(PORTLL,0x71) == 0)     //busy
	CALL SUBOPT_0x84
	CALL _sprawdz_pin0
	CPI  R30,0
	BRNE _0x271
; 0000 14DF                   {
; 0000 14E0                   PORTD.6 = 0;
	CBI  0x12,6
; 0000 14E1                   PORTC = 0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 14E2                   PORTD.5 = 0;
	CBI  0x12,5
; 0000 14E3                   sek3 = 0;
	CALL SUBOPT_0x93
; 0000 14E4                   cykl_sterownik_2 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x94
; 0000 14E5                   }
; 0000 14E6 
; 0000 14E7         break;
_0x271:
	RJMP _0x257
; 0000 14E8 
; 0000 14E9         case 3:
_0x270:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x276
; 0000 14EA 
; 0000 14EB                if(sprawdz_pin3(PORTLL,0x71) == 0)
	CALL SUBOPT_0x84
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x277
; 0000 14EC                   {
; 0000 14ED                   sek3 = 0;
	CALL SUBOPT_0x93
; 0000 14EE                   cykl_sterownik_2 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x94
; 0000 14EF                   }
; 0000 14F0 
; 0000 14F1 
; 0000 14F2         break;
_0x277:
	RJMP _0x257
; 0000 14F3 
; 0000 14F4 
; 0000 14F5         case 4:
_0x276:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x257
; 0000 14F6 
; 0000 14F7             if(sprawdz_pin0(PORTLL,0x71) == 1)
	CALL SUBOPT_0x84
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BRNE _0x279
; 0000 14F8                 {
; 0000 14F9                 cykl_sterownik_2 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
_0x4A6:
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R31
; 0000 14FA                 }
; 0000 14FB         break;
_0x279:
; 0000 14FC 
; 0000 14FD         }
_0x257:
; 0000 14FE 
; 0000 14FF return cykl_sterownik_2;
	LDS  R30,_cykl_sterownik_2
	LDS  R31,_cykl_sterownik_2+1
	RJMP _0x20A0001
; 0000 1500 }
;
;
;
;
;
;
;int sterownik_3_praca(int PORT)
; 0000 1508 {
_sterownik_3_praca:
; 0000 1509 //PORTF.0   IN0  STEROWNIK3
; 0000 150A //PORTF.1   IN1  STEROWNIK3
; 0000 150B //PORTF.2   IN2  STEROWNIK3
; 0000 150C //PORTF.3   IN3  STEROWNIK3
; 0000 150D //PORTF.7   IN4 STEROWNIK 3
; 0000 150E //PORTB.7   IN5 STEROWNIK 3
; 0000 150F 
; 0000 1510 
; 0000 1511 
; 0000 1512 //PORTF.5   DRIVE  STEROWNIK3
; 0000 1513 
; 0000 1514 //sprawdz_pin0(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK3
; 0000 1515 //sprawdz_pin3(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK3
; 0000 1516 
; 0000 1517 if(sprawdz_pin7(PORTMM,0x77) == 1)
;	PORT -> Y+0
	CALL SUBOPT_0x23
	CALL _sprawdz_pin7
	CPI  R30,LOW(0x1)
	BRNE _0x27A
; 0000 1518      {
; 0000 1519      PORTD.7 = 1;
	SBI  0x12,7
; 0000 151A      PORTE.2 = 0;
	CBI  0x3,2
; 0000 151B      PORTE.3 = 0;  //szlifierki stop
	CBI  0x3,3
; 0000 151C      }
; 0000 151D switch(cykl_sterownik_3)
_0x27A:
	LDS  R30,_cykl_sterownik_3
	LDS  R31,_cykl_sterownik_3+1
; 0000 151E         {
; 0000 151F         case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x284
; 0000 1520 
; 0000 1521             PORT_STER3.byte = PORT;
	LD   R30,Y
	STS  _PORT_STER3,R30
; 0000 1522             PORT_F.bits.b0 = PORT_STER3.bits.b0;
	ANDI R30,LOW(0x1)
	MOV  R0,R30
	LDS  R30,_PORT_F
	ANDI R30,0xFE
	CALL SUBOPT_0x95
; 0000 1523             PORT_F.bits.b1 = PORT_STER3.bits.b1;
	LSR  R30
	ANDI R30,LOW(0x1)
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_F
	ANDI R30,0xFD
	CALL SUBOPT_0x95
; 0000 1524             PORT_F.bits.b2 = PORT_STER3.bits.b2;
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x1)
	LSL  R30
	LSL  R30
	MOV  R0,R30
	LDS  R30,_PORT_F
	ANDI R30,0xFB
	CALL SUBOPT_0x95
; 0000 1525             PORT_F.bits.b3 = PORT_STER3.bits.b3;
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
	CALL SUBOPT_0x95
; 0000 1526             PORT_F.bits.b7 = PORT_STER3.bits.b4;
	SWAP R30
	ANDI R30,LOW(0x1)
	ROR  R30
	LDI  R30,0
	ROR  R30
	MOV  R0,R30
	LDS  R30,_PORT_F
	ANDI R30,0x7F
	OR   R30,R0
	CALL SUBOPT_0x96
; 0000 1527             PORTF = PORT_F.byte;
; 0000 1528             PORTB.7 = PORT_STER3.bits.b5;
	LDS  R30,_PORT_STER3
	ANDI R30,LOW(0x20)
	BRNE _0x285
	CBI  0x18,7
	RJMP _0x286
_0x285:
	SBI  0x18,7
_0x286:
; 0000 1529 
; 0000 152A 
; 0000 152B 
; 0000 152C             sek2 = 0;
	CALL SUBOPT_0x97
; 0000 152D             cykl_sterownik_3 = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x98
; 0000 152E 
; 0000 152F 
; 0000 1530 
; 0000 1531         break;
	RJMP _0x283
; 0000 1532 
; 0000 1533         case 1:
_0x284:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x287
; 0000 1534 
; 0000 1535 
; 0000 1536             if(sek2 > 1)
	LDS  R26,_sek2
	LDS  R27,_sek2+1
	LDS  R24,_sek2+2
	LDS  R25,_sek2+3
	CALL SUBOPT_0x91
	BRLT _0x288
; 0000 1537                 {
; 0000 1538 
; 0000 1539                 PORT_F.bits.b5 = 1;
	LDS  R30,_PORT_F
	ORI  R30,0x20
	CALL SUBOPT_0x96
; 0000 153A                 PORTF = PORT_F.byte;
; 0000 153B                 cykl_sterownik_3 = 2;    //drive
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x98
; 0000 153C                 }
; 0000 153D         break;
_0x288:
	RJMP _0x283
; 0000 153E 
; 0000 153F 
; 0000 1540         case 2:
_0x287:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x289
; 0000 1541 
; 0000 1542 
; 0000 1543                if(sprawdz_pin0(PORTKK,0x75) == 0)
	CALL SUBOPT_0x85
	CALL _sprawdz_pin0
	CPI  R30,0
	BRNE _0x28A
; 0000 1544                   {
; 0000 1545                   PORT_F.bits.b5 = 0;
	LDS  R30,_PORT_F
	ANDI R30,0xDF
	CALL SUBOPT_0x96
; 0000 1546                   PORTF = PORT_F.byte;
; 0000 1547 
; 0000 1548                   PORT_F.bits.b0 = 0;
	LDS  R30,_PORT_F
	ANDI R30,0xFE
	CALL SUBOPT_0x99
; 0000 1549                   PORT_F.bits.b1 = 0;
	ANDI R30,0xFD
	CALL SUBOPT_0x99
; 0000 154A                   PORT_F.bits.b2 = 0;
	ANDI R30,0xFB
	CALL SUBOPT_0x99
; 0000 154B                   PORT_F.bits.b3 = 0;
	ANDI R30,0XF7
	CALL SUBOPT_0x99
; 0000 154C                   PORT_F.bits.b7 = 0;
	ANDI R30,0x7F
	CALL SUBOPT_0x96
; 0000 154D                   PORTF = PORT_F.byte;
; 0000 154E                   PORTB.7 = 0;
	CBI  0x18,7
; 0000 154F 
; 0000 1550                   sek2 = 0;
	CALL SUBOPT_0x97
; 0000 1551                   cykl_sterownik_3 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x98
; 0000 1552                   }
; 0000 1553 
; 0000 1554         break;
_0x28A:
	RJMP _0x283
; 0000 1555 
; 0000 1556         case 3:
_0x289:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x28D
; 0000 1557 
; 0000 1558 
; 0000 1559                if(sprawdz_pin3(PORTKK,0x75) == 0)  //czy INP
	CALL SUBOPT_0x85
	CALL _sprawdz_pin3
	CPI  R30,0
	BRNE _0x28E
; 0000 155A                   {
; 0000 155B                   sek2 = 0;
	CALL SUBOPT_0x97
; 0000 155C                   cykl_sterownik_3 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x98
; 0000 155D                   }
; 0000 155E 
; 0000 155F 
; 0000 1560         break;
_0x28E:
	RJMP _0x283
; 0000 1561 
; 0000 1562 
; 0000 1563         case 4:
_0x28D:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x283
; 0000 1564 
; 0000 1565               if(sprawdz_pin0(PORTKK,0x75) == 1)  //czy BUSY
	CALL SUBOPT_0x85
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BRNE _0x290
; 0000 1566                 {
; 0000 1567                 cykl_sterownik_3 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x98
; 0000 1568 
; 0000 1569 
; 0000 156A                 switch(cykl_sterownik_3_wykonalem)
	LDS  R30,_cykl_sterownik_3_wykonalem
	LDS  R31,_cykl_sterownik_3_wykonalem+1
; 0000 156B                     {
; 0000 156C                     case 0:
	SBIW R30,0
	BRNE _0x294
; 0000 156D                             cykl_sterownik_3_wykonalem = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _cykl_sterownik_3_wykonalem,R30
	STS  _cykl_sterownik_3_wykonalem+1,R31
; 0000 156E                     break;
	RJMP _0x293
; 0000 156F 
; 0000 1570                     case 1:
_0x294:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x293
; 0000 1571                             cykl_sterownik_3_wykonalem = 0;
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_3_wykonalem,R30
	STS  _cykl_sterownik_3_wykonalem+1,R30
; 0000 1572                     break;
; 0000 1573 
; 0000 1574                     }
_0x293:
; 0000 1575 
; 0000 1576 
; 0000 1577                 }
; 0000 1578         break;
_0x290:
; 0000 1579 
; 0000 157A         }
_0x283:
; 0000 157B 
; 0000 157C return cykl_sterownik_3;
	LDS  R30,_cykl_sterownik_3
	LDS  R31,_cykl_sterownik_3+1
_0x20A0001:
	ADIW R28,2
	RET
; 0000 157D }
;
;//
;//int sterownik_4_praca(char f,char e,char d, char c, char b, char a)
;int sterownik_4_praca(int PORT,int p)
; 0000 1582 {
_sterownik_4_praca:
; 0000 1583 
; 0000 1584 
; 0000 1585 //PORTB.0   IN0  STEROWNIK4
; 0000 1586 //PORTB.1   IN1  STEROWNIK4
; 0000 1587 //PORTB.2   IN2  STEROWNIK4
; 0000 1588 //PORTB.3   IN3  STEROWNIK4
; 0000 1589 //PORTE.4  IN4  STEROWNIK4
; 0000 158A //PORTE.5  IN5  STEROWNIK4
; 0000 158B 
; 0000 158C 
; 0000 158D //PORTB.4   SETUP  STEROWNIK4
; 0000 158E //PORTB.5   DRIVE  STEROWNIK4
; 0000 158F 
; 0000 1590 //sprawdz_pin4(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK4
; 0000 1591 //sprawdz_pin7(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK4
; 0000 1592 
; 0000 1593 if(sprawdz_pin6(PORTMM,0x77) == 1)
;	PORT -> Y+2
;	p -> Y+0
	CALL SUBOPT_0x23
	CALL _sprawdz_pin6
	CPI  R30,LOW(0x1)
	BRNE _0x296
; 0000 1594     {
; 0000 1595     PORTD.7 = 1;
	SBI  0x12,7
; 0000 1596     PORTE.2 = 0;
	CBI  0x3,2
; 0000 1597     PORTE.3 = 0;
	CBI  0x3,3
; 0000 1598     }
; 0000 1599 switch(cykl_sterownik_4)
_0x296:
	LDS  R30,_cykl_sterownik_4
	LDS  R31,_cykl_sterownik_4+1
; 0000 159A         {
; 0000 159B         case 0:
	SBIW R30,0
	BRNE _0x2A0
; 0000 159C 
; 0000 159D             PORT_STER4.byte = PORT;
	LDD  R30,Y+2
	STS  _PORT_STER4,R30
; 0000 159E             PORTB.0 = PORT_STER4.bits.b0;
	ANDI R30,LOW(0x1)
	BRNE _0x2A1
	CBI  0x18,0
	RJMP _0x2A2
_0x2A1:
	SBI  0x18,0
_0x2A2:
; 0000 159F             PORTB.1 = PORT_STER4.bits.b1;
	LDS  R30,_PORT_STER4
	ANDI R30,LOW(0x2)
	BRNE _0x2A3
	CBI  0x18,1
	RJMP _0x2A4
_0x2A3:
	SBI  0x18,1
_0x2A4:
; 0000 15A0             PORTB.2 = PORT_STER4.bits.b2;
	LDS  R30,_PORT_STER4
	ANDI R30,LOW(0x4)
	BRNE _0x2A5
	CBI  0x18,2
	RJMP _0x2A6
_0x2A5:
	SBI  0x18,2
_0x2A6:
; 0000 15A1             PORTB.3 = PORT_STER4.bits.b3;
	LDS  R30,_PORT_STER4
	ANDI R30,LOW(0x8)
	BRNE _0x2A7
	CBI  0x18,3
	RJMP _0x2A8
_0x2A7:
	SBI  0x18,3
_0x2A8:
; 0000 15A2             PORTE.4 = PORT_STER4.bits.b4;
	LDS  R30,_PORT_STER4
	ANDI R30,LOW(0x10)
	BRNE _0x2A9
	CBI  0x3,4
	RJMP _0x2AA
_0x2A9:
	SBI  0x3,4
_0x2AA:
; 0000 15A3             PORTE.5 = PORT_STER4.bits.b5;
	LDS  R30,_PORT_STER4
	ANDI R30,LOW(0x20)
	BRNE _0x2AB
	CBI  0x3,5
	RJMP _0x2AC
_0x2AB:
	SBI  0x3,5
_0x2AC:
; 0000 15A4 
; 0000 15A5             sek4 = 0;
	CALL SUBOPT_0x9A
; 0000 15A6             cykl_sterownik_4 = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x4A7
; 0000 15A7 
; 0000 15A8         break;
; 0000 15A9 
; 0000 15AA         case 1:
_0x2A0:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2AD
; 0000 15AB 
; 0000 15AC             if(sek4 > 1)
	LDS  R26,_sek4
	LDS  R27,_sek4+1
	LDS  R24,_sek4+2
	LDS  R25,_sek4+3
	CALL SUBOPT_0x91
	BRLT _0x2AE
; 0000 15AD                 {
; 0000 15AE                 PORTB.5 = 1;
	SBI  0x18,5
; 0000 15AF                 cykl_sterownik_4 = 2;    //drive
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x9B
; 0000 15B0                 }
; 0000 15B1         break;
_0x2AE:
	RJMP _0x29F
; 0000 15B2 
; 0000 15B3 
; 0000 15B4         case 2:
_0x2AD:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2B1
; 0000 15B5 
; 0000 15B6                if(sprawdz_pin4(PORTKK,0x75) == 0)
	CALL SUBOPT_0x85
	CALL _sprawdz_pin4
	CPI  R30,0
	BRNE _0x2B2
; 0000 15B7                   {
; 0000 15B8                   PORTB.5 = 0;  //drive
	CBI  0x18,5
; 0000 15B9 
; 0000 15BA                   PORTB.0 = 0;
	CBI  0x18,0
; 0000 15BB                   PORTB.1 = 0;
	CBI  0x18,1
; 0000 15BC                   PORTB.2 = 0;
	CBI  0x18,2
; 0000 15BD                   PORTB.3 = 0;
	CBI  0x18,3
; 0000 15BE                   PORTE.4 = 0;
	CBI  0x3,4
; 0000 15BF                   PORTE.5 = 0;
	CBI  0x3,5
; 0000 15C0 
; 0000 15C1                   sek4 = 0;
	CALL SUBOPT_0x9A
; 0000 15C2                   cykl_sterownik_4 = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x9B
; 0000 15C3                   }
; 0000 15C4 
; 0000 15C5         break;
_0x2B2:
	RJMP _0x29F
; 0000 15C6 
; 0000 15C7         case 3:
_0x2B1:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2C1
; 0000 15C8 
; 0000 15C9                if(sprawdz_pin7(PORTKK,0x75) == 0)  //czy INP
	CALL SUBOPT_0x85
	CALL _sprawdz_pin7
	CPI  R30,0
	BRNE _0x2C2
; 0000 15CA                   {
; 0000 15CB                   if(p == 1)
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,1
	BRNE _0x2C3
; 0000 15CC                     PORTE.2 = 1;
	SBI  0x3,2
; 0000 15CD 
; 0000 15CE                   sek4 = 0;
_0x2C3:
	CALL SUBOPT_0x9A
; 0000 15CF                   cykl_sterownik_4 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x9B
; 0000 15D0                   }
; 0000 15D1 
; 0000 15D2 
; 0000 15D3         break;
_0x2C2:
	RJMP _0x29F
; 0000 15D4 
; 0000 15D5 
; 0000 15D6         case 4:
_0x2C1:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x29F
; 0000 15D7 
; 0000 15D8               if(sprawdz_pin4(PORTKK,0x75) == 1)  //czy BUSY
	CALL SUBOPT_0x85
	CALL _sprawdz_pin4
	CPI  R30,LOW(0x1)
	BRNE _0x2C7
; 0000 15D9                 {
; 0000 15DA                 cykl_sterownik_4 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
_0x4A7:
	STS  _cykl_sterownik_4,R30
	STS  _cykl_sterownik_4+1,R31
; 0000 15DB                 }
; 0000 15DC         break;
_0x2C7:
; 0000 15DD 
; 0000 15DE         }
_0x29F:
; 0000 15DF 
; 0000 15E0 return cykl_sterownik_4;
	LDS  R30,_cykl_sterownik_4
	LDS  R31,_cykl_sterownik_4+1
	ADIW R28,4
	RET
; 0000 15E1 }
;
;
;void test_geometryczny()
; 0000 15E5 {
_test_geometryczny:
; 0000 15E6 int cykl_testu,d;
; 0000 15E7 int ff[12];
; 0000 15E8 int i;
; 0000 15E9 d = 0;
	SBIW R28,24
	CALL __SAVELOCR6
;	cykl_testu -> R16,R17
;	d -> R18,R19
;	ff -> Y+6
;	i -> R20,R21
	__GETWRN 18,19,0
; 0000 15EA cykl_testu = 0;
	__GETWRN 16,17,0
; 0000 15EB 
; 0000 15EC for(i=0;i<11;i++)
	__GETWRN 20,21,0
_0x2C9:
	__CPWRN 20,21,11
	BRGE _0x2CA
; 0000 15ED      ff[i]=0;
	MOVW R30,R20
	CALL SUBOPT_0x9C
	CALL SUBOPT_0x3A
	__ADDWRN 20,21,1
	RJMP _0x2C9
_0x2CA:
; 0000 15F0 if(test_geometryczny_rzad_1 == 1 & test_geometryczny_rzad_2 == 0 & PORTD.7 == 0  & PORT_F.bits.b6 == 0 &
; 0000 15F1     il_zaciskow_rzad_1 > 1 & macierz_zaciskow[1]!=0)
	CALL SUBOPT_0x9D
	CALL SUBOPT_0x7A
	MOV  R0,R30
	CALL SUBOPT_0x9E
	CALL SUBOPT_0x8B
	CALL SUBOPT_0x9F
	CALL SUBOPT_0xA0
	CALL SUBOPT_0xA1
	BRNE PC+3
	JMP _0x2CB
; 0000 15F2     {
; 0000 15F3     while(test_geometryczny_rzad_1 == 1)
_0x2CC:
	CALL SUBOPT_0x9D
	SBIW R26,1
	BREQ PC+3
	JMP _0x2CE
; 0000 15F4         {
; 0000 15F5         switch(cykl_testu)
	MOVW R30,R16
; 0000 15F6             {
; 0000 15F7              case 0:
	SBIW R30,0
	BRNE _0x2D2
; 0000 15F8 
; 0000 15F9                cykl_sterownik_1 = 0;
	CALL SUBOPT_0xA2
; 0000 15FA                cykl_sterownik_2 = 0;
; 0000 15FB                cykl_sterownik_3 = 0;
; 0000 15FC                cykl_sterownik_4 = 0;
; 0000 15FD                wybor_linijek_sterownikow(1);
	CALL SUBOPT_0xA3
	CALL _wybor_linijek_sterownikow
; 0000 15FE                cykl_testu = 1;
	__GETWRN 16,17,1
; 0000 15FF 
; 0000 1600 
; 0000 1601 
; 0000 1602             break;
	RJMP _0x2D1
; 0000 1603 
; 0000 1604             case 1:
_0x2D2:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2D3
; 0000 1605 
; 0000 1606             //na sam dol zjezdzamy pionami
; 0000 1607                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xA4
	SBIW R26,5
	BRGE _0x2D4
; 0000 1608                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x24
	CALL SUBOPT_0xA5
; 0000 1609                 if(cykl_sterownik_4 < 5)
_0x2D4:
	CALL SUBOPT_0xA6
	SBIW R26,5
	BRGE _0x2D5
; 0000 160A                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x89
	CALL SUBOPT_0xA7
; 0000 160B 
; 0000 160C                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x2D5:
	CALL SUBOPT_0xA8
	BREQ _0x2D6
; 0000 160D                                         {
; 0000 160E                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xA9
; 0000 160F                                         cykl_sterownik_4 = 0;
; 0000 1610                                         cykl_testu = 2;
	__GETWRN 16,17,2
; 0000 1611                                         }
; 0000 1612 
; 0000 1613 
; 0000 1614 
; 0000 1615             break;
_0x2D6:
	RJMP _0x2D1
; 0000 1616 
; 0000 1617 
; 0000 1618             case 2:
_0x2D3:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2D7
; 0000 1619 
; 0000 161A                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xAA
	SBIW R26,5
	BRGE _0x2D8
; 0000 161B                                     cykl_sterownik_1 = sterownik_1_praca(0x000);
	CALL SUBOPT_0x24
	CALL SUBOPT_0xAB
; 0000 161C                                  if(cykl_sterownik_2 < 5)                                //ster 1 pod pin pozycjonujacy
_0x2D8:
	CALL SUBOPT_0xAC
	SBIW R26,5
	BRGE _0x2D9
; 0000 161D                                     cykl_sterownik_2 = sterownik_2_praca(0x008);       //ster 2 ucieczka do zera (druciak)
	CALL SUBOPT_0xAD
	CALL SUBOPT_0xAE
; 0000 161E 
; 0000 161F                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x2D9:
	CALL SUBOPT_0xAF
	BREQ _0x2DA
; 0000 1620                                         {
; 0000 1621                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xA2
; 0000 1622                                         cykl_sterownik_2 = 0;
; 0000 1623                                         cykl_sterownik_3 = 0;
; 0000 1624                                         cykl_sterownik_4 = 0;
; 0000 1625                                         cykl_testu = 3;
	__GETWRN 16,17,3
; 0000 1626 
; 0000 1627                                         }
; 0000 1628 
; 0000 1629             break;
_0x2DA:
	RJMP _0x2D1
; 0000 162A 
; 0000 162B 
; 0000 162C             case 3:
_0x2D7:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2DB
; 0000 162D 
; 0000 162E                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xAA
	SBIW R26,5
	BRGE _0x2DC
; 0000 162F                                     cykl_sterownik_1 = sterownik_1_praca(a[0]); //ster 1 pod srodek zacisku
	CALL SUBOPT_0xB0
	CALL SUBOPT_0xAB
; 0000 1630 
; 0000 1631                                     if(cykl_sterownik_1 == 5)
_0x2DC:
	CALL SUBOPT_0xAA
	SBIW R26,5
	BRNE _0x2DD
; 0000 1632                                         {
; 0000 1633                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xA2
; 0000 1634                                         cykl_sterownik_2 = 0;
; 0000 1635                                         cykl_sterownik_3 = 0;
; 0000 1636                                         cykl_sterownik_4 = 0;
; 0000 1637                                         cykl_testu = 4;
	__GETWRN 16,17,4
; 0000 1638                                         }
; 0000 1639 
; 0000 163A             break;
_0x2DD:
	RJMP _0x2D1
; 0000 163B 
; 0000 163C             case 4:
_0x2DB:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2DE
; 0000 163D 
; 0000 163E                                    if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xA4
	SBIW R26,5
	BRGE _0x2DF
; 0000 163F                                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //abs
	CALL SUBOPT_0x73
	CALL SUBOPT_0xB1
; 0000 1640 
; 0000 1641                                    if(cykl_sterownik_3 == 5)
_0x2DF:
	CALL SUBOPT_0xA4
	SBIW R26,5
	BRNE _0x2E0
; 0000 1642                                         {
; 0000 1643                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xA2
; 0000 1644                                         cykl_sterownik_2 = 0;
; 0000 1645                                         cykl_sterownik_3 = 0;
; 0000 1646                                         cykl_sterownik_4 = 0;
; 0000 1647                                         cykl_testu = 5;
	__GETWRN 16,17,5
; 0000 1648                                         }
; 0000 1649 
; 0000 164A             break;
_0x2E0:
	RJMP _0x2D1
; 0000 164B 
; 0000 164C             case 5:
_0x2DE:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x2E1
; 0000 164D 
; 0000 164E                                      d = odczytaj_parametr(48,80);
	CALL SUBOPT_0x11
	CALL SUBOPT_0x2E
	CALL _odczytaj_parametr
	MOVW R18,R30
; 0000 164F                                         if(d == 0)
	MOV  R0,R18
	OR   R0,R19
	BRNE _0x2E2
; 0000 1650                                             cykl_testu = 666;
	__GETWRN 16,17,666
; 0000 1651 
; 0000 1652                                         if(d == 2 & ff[2] == 0)
_0x2E2:
	CALL SUBOPT_0xB2
	BREQ _0x2E3
; 0000 1653                                             {
; 0000 1654                                             cykl_testu = 6;
	CALL SUBOPT_0xB3
; 0000 1655                                             ff[d]=1;
	CALL SUBOPT_0x36
; 0000 1656                                             }
; 0000 1657                                         if(d == 3 & ff[2] == 1 & ff[3] == 0)
_0x2E3:
	CALL SUBOPT_0xB4
	AND  R0,R30
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL SUBOPT_0x8B
	AND  R30,R0
	BREQ _0x2E4
; 0000 1658                                             {
; 0000 1659                                             cykl_testu = 6;
	CALL SUBOPT_0xB3
; 0000 165A                                             ff[d]=1;
	CALL SUBOPT_0x36
; 0000 165B                                             }
; 0000 165C                                         if(d == 4 & ff[3] == 1 & ff[4] == 0)
_0x2E4:
	CALL SUBOPT_0xB5
	AND  R0,R30
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL SUBOPT_0x8B
	AND  R30,R0
	BREQ _0x2E5
; 0000 165D                                             {
; 0000 165E                                             cykl_testu = 6;
	CALL SUBOPT_0xB3
; 0000 165F                                             ff[d]=1;
	CALL SUBOPT_0x36
; 0000 1660                                             }
; 0000 1661                                         if(d == 5 & ff[4] == 1 & ff[5] == 0)
_0x2E5:
	CALL SUBOPT_0xB6
	AND  R0,R30
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	CALL SUBOPT_0x8B
	AND  R30,R0
	BREQ _0x2E6
; 0000 1662                                             {
; 0000 1663                                             cykl_testu = 6;
	CALL SUBOPT_0xB3
; 0000 1664                                             ff[d]=1;
	CALL SUBOPT_0x36
; 0000 1665                                             }
; 0000 1666                                         if(d == 6 & ff[5] == 1 & ff[6] == 0)
_0x2E6:
	CALL SUBOPT_0xB7
	AND  R0,R30
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	CALL SUBOPT_0x8B
	AND  R30,R0
	BREQ _0x2E7
; 0000 1667                                             {
; 0000 1668                                             cykl_testu = 6;
	CALL SUBOPT_0xB3
; 0000 1669                                             ff[d]=1;
	CALL SUBOPT_0x36
; 0000 166A                                             }
; 0000 166B                                         if(d == 7 & ff[6] == 1 & ff[7] == 0)
_0x2E7:
	CALL SUBOPT_0xB8
	AND  R0,R30
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	CALL SUBOPT_0x8B
	AND  R30,R0
	BREQ _0x2E8
; 0000 166C                                             {
; 0000 166D                                             cykl_testu = 6;
	CALL SUBOPT_0xB3
; 0000 166E                                             ff[d]=1;
	CALL SUBOPT_0x36
; 0000 166F                                             }
; 0000 1670                                         if(d == 8 & ff[7] == 1 & ff[8] == 0)
_0x2E8:
	CALL SUBOPT_0xB9
	AND  R0,R30
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CALL SUBOPT_0x8B
	AND  R30,R0
	BREQ _0x2E9
; 0000 1671                                             {
; 0000 1672                                             cykl_testu = 6;
	CALL SUBOPT_0xB3
; 0000 1673                                             ff[d]=1;
	CALL SUBOPT_0x36
; 0000 1674                                             }
; 0000 1675                                         if(d == 9 & ff[8] == 1 & ff[9] == 0)
_0x2E9:
	CALL SUBOPT_0xBA
	AND  R0,R30
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	CALL SUBOPT_0x8B
	AND  R30,R0
	BREQ _0x2EA
; 0000 1676                                             {
; 0000 1677                                             cykl_testu = 6;
	CALL SUBOPT_0xB3
; 0000 1678                                             ff[d]=1;
	CALL SUBOPT_0x36
; 0000 1679                                             }
; 0000 167A                                         if(d == 10 & ff[9] == 1 & ff[10] == 0)
_0x2EA:
	CALL SUBOPT_0xBB
	AND  R0,R30
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	CALL SUBOPT_0x8B
	AND  R30,R0
	BREQ _0x2EB
; 0000 167B                                             {
; 0000 167C                                             cykl_testu = 6;
	CALL SUBOPT_0xB3
; 0000 167D                                             ff[d]=1;
	CALL SUBOPT_0x36
; 0000 167E                                             }
; 0000 167F 
; 0000 1680 
; 0000 1681             break;
_0x2EB:
	RJMP _0x2D1
; 0000 1682 
; 0000 1683             case 6:
_0x2E1:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x2EC
; 0000 1684                                      if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xA4
	SBIW R26,5
	BRGE _0x2ED
; 0000 1685                                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x24
	CALL SUBOPT_0xA5
; 0000 1686                                         if(cykl_sterownik_3 == 5)
_0x2ED:
	CALL SUBOPT_0xA4
	SBIW R26,5
	BRNE _0x2EE
; 0000 1687                                             {
; 0000 1688                                             cykl_sterownik_1 = 0;
	CALL SUBOPT_0xA2
; 0000 1689                                             cykl_sterownik_2 = 0;
; 0000 168A                                             cykl_sterownik_3 = 0;
; 0000 168B                                             cykl_sterownik_4 = 0;
; 0000 168C                                             cykl_testu = 7;
	__GETWRN 16,17,7
; 0000 168D                                             }
; 0000 168E 
; 0000 168F             break;
_0x2EE:
	RJMP _0x2D1
; 0000 1690 
; 0000 1691             case 7:
_0x2EC:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x2EF
; 0000 1692 
; 0000 1693                                     if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xAA
	SBIW R26,5
	BRGE _0x2F0
; 0000 1694                                         cykl_sterownik_1 = sterownik_1_praca(0x003);     //pod nastepny dolek
	CALL SUBOPT_0xBC
; 0000 1695 
; 0000 1696                                     if(cykl_sterownik_1 == 5)
_0x2F0:
	CALL SUBOPT_0xAA
	SBIW R26,5
	BRNE _0x2F1
; 0000 1697                                         {
; 0000 1698                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xA2
; 0000 1699                                         cykl_sterownik_2 = 0;
; 0000 169A                                         cykl_sterownik_3 = 0;
; 0000 169B                                         cykl_sterownik_4 = 0;
; 0000 169C                                         cykl_testu = 4;
	__GETWRN 16,17,4
; 0000 169D                                         }
; 0000 169E 
; 0000 169F 
; 0000 16A0             break;
_0x2F1:
	RJMP _0x2D1
; 0000 16A1 
; 0000 16A2 
; 0000 16A3 
; 0000 16A4 
; 0000 16A5 
; 0000 16A6 
; 0000 16A7 
; 0000 16A8             case 666:
_0x2EF:
	CPI  R30,LOW(0x29A)
	LDI  R26,HIGH(0x29A)
	CPC  R31,R26
	BRNE _0x2D1
; 0000 16A9 
; 0000 16AA                                         if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xA4
	SBIW R26,5
	BRGE _0x2F3
; 0000 16AB                                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x24
	CALL SUBOPT_0xA5
; 0000 16AC                                         if(cykl_sterownik_3 == 5)
_0x2F3:
	CALL SUBOPT_0xA4
	SBIW R26,5
	BRNE _0x2F4
; 0000 16AD                                             {
; 0000 16AE                                             cykl_sterownik_3 = 0;
	CALL SUBOPT_0xA9
; 0000 16AF                                             cykl_sterownik_4 = 0;
; 0000 16B0                                             cykl_testu = 100;
	__GETWRN 16,17,100
; 0000 16B1                                             test_geometryczny_rzad_1 = 0;
	LDI  R30,LOW(0)
	STS  _test_geometryczny_rzad_1,R30
	STS  _test_geometryczny_rzad_1+1,R30
; 0000 16B2                                             }
; 0000 16B3 
; 0000 16B4             break;
_0x2F4:
; 0000 16B5 
; 0000 16B6 
; 0000 16B7 
; 0000 16B8             }
_0x2D1:
; 0000 16B9 
; 0000 16BA         }
	RJMP _0x2CC
_0x2CE:
; 0000 16BB     }
; 0000 16BC 
; 0000 16BD 
; 0000 16BE 
; 0000 16BF                                                                    //swiatlo czer       //swiatlo zolte
; 0000 16C0 if(test_geometryczny_rzad_1 == 0 & test_geometryczny_rzad_2 == 1 & PORTD.7 == 0  & PORT_F.bits.b6 == 0 &
_0x2CB:
; 0000 16C1     il_zaciskow_rzad_2 > 0 & macierz_zaciskow[2]!=0)
	CALL SUBOPT_0x9D
	CALL SUBOPT_0x8B
	MOV  R0,R30
	CALL SUBOPT_0x9E
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x9F
	CALL SUBOPT_0xBD
	CALL SUBOPT_0xBE
	AND  R0,R30
	CALL SUBOPT_0xBF
	AND  R30,R0
	BRNE PC+3
	JMP _0x2F5
; 0000 16C2     {
; 0000 16C3     while(test_geometryczny_rzad_2 == 1)
_0x2F6:
	CALL SUBOPT_0x9E
	SBIW R26,1
	BREQ PC+3
	JMP _0x2F8
; 0000 16C4         {
; 0000 16C5         switch(cykl_testu)
	MOVW R30,R16
; 0000 16C6             {
; 0000 16C7              case 0:
	SBIW R30,0
	BRNE _0x2FC
; 0000 16C8 
; 0000 16C9                cykl_sterownik_1 = 0;
	CALL SUBOPT_0xA2
; 0000 16CA                cykl_sterownik_2 = 0;
; 0000 16CB                cykl_sterownik_3 = 0;
; 0000 16CC                cykl_sterownik_4 = 0;
; 0000 16CD                wybor_linijek_sterownikow(2);
	CALL SUBOPT_0xC0
; 0000 16CE                cykl_testu = 1;
	__GETWRN 16,17,1
; 0000 16CF 
; 0000 16D0 
; 0000 16D1 
; 0000 16D2             break;
	RJMP _0x2FB
; 0000 16D3 
; 0000 16D4             case 1:
_0x2FC:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2FD
; 0000 16D5 
; 0000 16D6             //na sam dol zjezdzamy pionami
; 0000 16D7                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xA4
	SBIW R26,5
	BRGE _0x2FE
; 0000 16D8                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x24
	CALL SUBOPT_0xA5
; 0000 16D9                 if(cykl_sterownik_4 < 5)
_0x2FE:
	CALL SUBOPT_0xA6
	SBIW R26,5
	BRGE _0x2FF
; 0000 16DA                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x89
	CALL SUBOPT_0xA7
; 0000 16DB 
; 0000 16DC                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x2FF:
	CALL SUBOPT_0xA8
	BREQ _0x300
; 0000 16DD                                         {
; 0000 16DE                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xA9
; 0000 16DF                                         cykl_sterownik_4 = 0;
; 0000 16E0                                         cykl_testu = 2;
	__GETWRN 16,17,2
; 0000 16E1                                         }
; 0000 16E2 
; 0000 16E3 
; 0000 16E4 
; 0000 16E5             break;
_0x300:
	RJMP _0x2FB
; 0000 16E6 
; 0000 16E7 
; 0000 16E8             case 2:
_0x2FD:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x301
; 0000 16E9 
; 0000 16EA                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xAA
	SBIW R26,5
	BRGE _0x302
; 0000 16EB                                     cykl_sterownik_1 = sterownik_1_praca(0x001);
	CALL SUBOPT_0xA3
	CALL SUBOPT_0xAB
; 0000 16EC                                  if(cykl_sterownik_2 < 5)                                //ster 1 pod pin pozycjonujacy rzad 2
_0x302:
	CALL SUBOPT_0xAC
	SBIW R26,5
	BRGE _0x303
; 0000 16ED                                     cykl_sterownik_2 = sterownik_2_praca(0x009);       //ster 2 ucieczka dla II rzedu (druciak)
	CALL SUBOPT_0xC1
	CALL SUBOPT_0xAE
; 0000 16EE 
; 0000 16EF                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x303:
	CALL SUBOPT_0xAF
	BREQ _0x304
; 0000 16F0                                         {
; 0000 16F1                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xA2
; 0000 16F2                                         cykl_sterownik_2 = 0;
; 0000 16F3                                         cykl_sterownik_3 = 0;
; 0000 16F4                                         cykl_sterownik_4 = 0;
; 0000 16F5                                         cykl_testu = 3;
	__GETWRN 16,17,3
; 0000 16F6 
; 0000 16F7                                         }
; 0000 16F8 
; 0000 16F9             break;
_0x304:
	RJMP _0x2FB
; 0000 16FA 
; 0000 16FB 
; 0000 16FC             case 3:
_0x301:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x305
; 0000 16FD 
; 0000 16FE                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xAA
	SBIW R26,5
	BRGE _0x306
; 0000 16FF                                     cykl_sterownik_1 = sterownik_1_praca(a[1]); //ster 1 pod srodek zacisku
	CALL SUBOPT_0xC2
	CALL SUBOPT_0xAB
; 0000 1700 
; 0000 1701                                     if(cykl_sterownik_1 == 5)
_0x306:
	CALL SUBOPT_0xAA
	SBIW R26,5
	BRNE _0x307
; 0000 1702                                         {
; 0000 1703                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xA2
; 0000 1704                                         cykl_sterownik_2 = 0;
; 0000 1705                                         cykl_sterownik_3 = 0;
; 0000 1706                                         cykl_sterownik_4 = 0;
; 0000 1707                                         cykl_testu = 4;
	__GETWRN 16,17,4
; 0000 1708                                         }
; 0000 1709 
; 0000 170A             break;
_0x307:
	RJMP _0x2FB
; 0000 170B 
; 0000 170C             case 4:
_0x305:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x308
; 0000 170D 
; 0000 170E                                    if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xA4
	SBIW R26,5
	BRGE _0x309
; 0000 170F                                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //abs
	CALL SUBOPT_0x73
	CALL SUBOPT_0xB1
; 0000 1710 
; 0000 1711                                    if(cykl_sterownik_3 == 5)
_0x309:
	CALL SUBOPT_0xA4
	SBIW R26,5
	BRNE _0x30A
; 0000 1712                                         {
; 0000 1713                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xA2
; 0000 1714                                         cykl_sterownik_2 = 0;
; 0000 1715                                         cykl_sterownik_3 = 0;
; 0000 1716                                         cykl_sterownik_4 = 0;
; 0000 1717                                         cykl_testu = 5;
	__GETWRN 16,17,5
; 0000 1718                                         }
; 0000 1719 
; 0000 171A             break;
_0x30A:
	RJMP _0x2FB
; 0000 171B 
; 0000 171C             case 5:
_0x308:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x30B
; 0000 171D 
; 0000 171E                                      d = odczytaj_parametr(48,96);
	CALL SUBOPT_0x11
	CALL SUBOPT_0x2F
	CALL _odczytaj_parametr
	MOVW R18,R30
; 0000 171F                                         if(d == 0)
	MOV  R0,R18
	OR   R0,R19
	BRNE _0x30C
; 0000 1720                                             cykl_testu = 666;
	__GETWRN 16,17,666
; 0000 1721 
; 0000 1722 
; 0000 1723 
; 0000 1724 
; 0000 1725                                         if(d == 2 & ff[2] == 0)
_0x30C:
	CALL SUBOPT_0xB2
	BREQ _0x30D
; 0000 1726                                             {
; 0000 1727                                             cykl_testu = 6;
	CALL SUBOPT_0xB3
; 0000 1728                                             ff[d]=1;
	CALL SUBOPT_0x36
; 0000 1729                                             }
; 0000 172A                                         if(d == 3 & ff[2] == 1 & ff[3] == 0)
_0x30D:
	CALL SUBOPT_0xB4
	AND  R0,R30
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL SUBOPT_0x8B
	AND  R30,R0
	BREQ _0x30E
; 0000 172B                                             {
; 0000 172C                                             cykl_testu = 6;
	CALL SUBOPT_0xB3
; 0000 172D                                             ff[d]=1;
	CALL SUBOPT_0x36
; 0000 172E                                             }
; 0000 172F                                         if(d == 4 & ff[3] == 1 & ff[4] == 0)
_0x30E:
	CALL SUBOPT_0xB5
	AND  R0,R30
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL SUBOPT_0x8B
	AND  R30,R0
	BREQ _0x30F
; 0000 1730                                             {
; 0000 1731                                             cykl_testu = 6;
	CALL SUBOPT_0xB3
; 0000 1732                                             ff[d]=1;
	CALL SUBOPT_0x36
; 0000 1733                                             }
; 0000 1734                                         if(d == 5 & ff[4] == 1 & ff[5] == 0)
_0x30F:
	CALL SUBOPT_0xB6
	AND  R0,R30
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	CALL SUBOPT_0x8B
	AND  R30,R0
	BREQ _0x310
; 0000 1735                                             {
; 0000 1736                                             cykl_testu = 6;
	CALL SUBOPT_0xB3
; 0000 1737                                             ff[d]=1;
	CALL SUBOPT_0x36
; 0000 1738                                             }
; 0000 1739                                         if(d == 6 & ff[5] == 1 & ff[6] == 0)
_0x310:
	CALL SUBOPT_0xB7
	AND  R0,R30
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	CALL SUBOPT_0x8B
	AND  R30,R0
	BREQ _0x311
; 0000 173A                                             {
; 0000 173B                                             cykl_testu = 6;
	CALL SUBOPT_0xB3
; 0000 173C                                             ff[d]=1;
	CALL SUBOPT_0x36
; 0000 173D                                             }
; 0000 173E                                         if(d == 7 & ff[6] == 1 & ff[7] == 0)
_0x311:
	CALL SUBOPT_0xB8
	AND  R0,R30
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	CALL SUBOPT_0x8B
	AND  R30,R0
	BREQ _0x312
; 0000 173F                                             {
; 0000 1740                                             cykl_testu = 6;
	CALL SUBOPT_0xB3
; 0000 1741                                             ff[d]=1;
	CALL SUBOPT_0x36
; 0000 1742                                             }
; 0000 1743                                         if(d == 8 & ff[7] == 1 & ff[8] == 0)
_0x312:
	CALL SUBOPT_0xB9
	AND  R0,R30
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CALL SUBOPT_0x8B
	AND  R30,R0
	BREQ _0x313
; 0000 1744                                             {
; 0000 1745                                             cykl_testu = 6;
	CALL SUBOPT_0xB3
; 0000 1746                                             ff[d]=1;
	CALL SUBOPT_0x36
; 0000 1747                                             }
; 0000 1748                                         if(d == 9 & ff[8] == 1 & ff[9] == 0)
_0x313:
	CALL SUBOPT_0xBA
	AND  R0,R30
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	CALL SUBOPT_0x8B
	AND  R30,R0
	BREQ _0x314
; 0000 1749                                             {
; 0000 174A                                             cykl_testu = 6;
	CALL SUBOPT_0xB3
; 0000 174B                                             ff[d]=1;
	CALL SUBOPT_0x36
; 0000 174C                                             }
; 0000 174D                                         if(d == 10 & ff[9] == 1 & ff[10] == 0)
_0x314:
	CALL SUBOPT_0xBB
	AND  R0,R30
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	CALL SUBOPT_0x8B
	AND  R30,R0
	BREQ _0x315
; 0000 174E                                             {
; 0000 174F                                             cykl_testu = 6;
	CALL SUBOPT_0xB3
; 0000 1750                                             ff[d]=1;
	CALL SUBOPT_0x36
; 0000 1751                                             }
; 0000 1752 
; 0000 1753 
; 0000 1754             break;
_0x315:
	RJMP _0x2FB
; 0000 1755 
; 0000 1756             case 6:
_0x30B:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x316
; 0000 1757                                      if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xA4
	SBIW R26,5
	BRGE _0x317
; 0000 1758                                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x24
	CALL SUBOPT_0xA5
; 0000 1759                                         if(cykl_sterownik_3 == 5)
_0x317:
	CALL SUBOPT_0xA4
	SBIW R26,5
	BRNE _0x318
; 0000 175A                                             {
; 0000 175B                                             cykl_sterownik_1 = 0;
	CALL SUBOPT_0xA2
; 0000 175C                                             cykl_sterownik_2 = 0;
; 0000 175D                                             cykl_sterownik_3 = 0;
; 0000 175E                                             cykl_sterownik_4 = 0;
; 0000 175F                                             cykl_testu = 7;
	__GETWRN 16,17,7
; 0000 1760                                             }
; 0000 1761 
; 0000 1762             break;
_0x318:
	RJMP _0x2FB
; 0000 1763 
; 0000 1764             case 7:
_0x316:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x319
; 0000 1765 
; 0000 1766                                     if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xAA
	SBIW R26,5
	BRGE _0x31A
; 0000 1767                                         cykl_sterownik_1 = sterownik_1_praca(0x003);     //pod nastepny dolek
	CALL SUBOPT_0xBC
; 0000 1768 
; 0000 1769                                     if(cykl_sterownik_1 == 5)
_0x31A:
	CALL SUBOPT_0xAA
	SBIW R26,5
	BRNE _0x31B
; 0000 176A                                         {
; 0000 176B                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xA2
; 0000 176C                                         cykl_sterownik_2 = 0;
; 0000 176D                                         cykl_sterownik_3 = 0;
; 0000 176E                                         cykl_sterownik_4 = 0;
; 0000 176F                                         cykl_testu = 4;
	__GETWRN 16,17,4
; 0000 1770                                         }
; 0000 1771 
; 0000 1772 
; 0000 1773             break;
_0x31B:
	RJMP _0x2FB
; 0000 1774 
; 0000 1775 
; 0000 1776 
; 0000 1777             case 666:
_0x319:
	CPI  R30,LOW(0x29A)
	LDI  R26,HIGH(0x29A)
	CPC  R31,R26
	BRNE _0x2FB
; 0000 1778 
; 0000 1779                                         if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xA4
	SBIW R26,5
	BRGE _0x31D
; 0000 177A                                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x24
	CALL SUBOPT_0xA5
; 0000 177B                                         if(cykl_sterownik_3 == 5)
_0x31D:
	CALL SUBOPT_0xA4
	SBIW R26,5
	BRNE _0x31E
; 0000 177C                                             {
; 0000 177D                                             cykl_sterownik_3 = 0;
	CALL SUBOPT_0xA9
; 0000 177E                                             cykl_sterownik_4 = 0;
; 0000 177F                                             cykl_testu = 100;
	__GETWRN 16,17,100
; 0000 1780                                             test_geometryczny_rzad_2 = 0;
	LDI  R30,LOW(0)
	STS  _test_geometryczny_rzad_2,R30
	STS  _test_geometryczny_rzad_2+1,R30
; 0000 1781                                             }
; 0000 1782 
; 0000 1783             break;
_0x31E:
; 0000 1784 
; 0000 1785 
; 0000 1786 
; 0000 1787             }
_0x2FB:
; 0000 1788 
; 0000 1789         }
	RJMP _0x2F6
_0x2F8:
; 0000 178A     }
; 0000 178B 
; 0000 178C 
; 0000 178D 
; 0000 178E 
; 0000 178F 
; 0000 1790 }
_0x2F5:
	CALL __LOADLOCR6
	ADIW R28,30
	RET
;
;
;
;
;
;void kontrola_zoltego_swiatla()
; 0000 1797 {
_kontrola_zoltego_swiatla:
; 0000 1798 
; 0000 1799 
; 0000 179A if(czas_pracy_szczotki_drucianej_h >= czas_pracy_szczotki_drucianej_stala)
	CALL SUBOPT_0x9
	MOVW R0,R30
	CALL SUBOPT_0x1C
	CP   R0,R30
	CPC  R1,R31
	BRLT _0x31F
; 0000 179B      {
; 0000 179C      PORT_F.bits.b6 = 1;
	LDS  R30,_PORT_F
	ORI  R30,0x40
	CALL SUBOPT_0x96
; 0000 179D      PORTF = PORT_F.byte;
; 0000 179E      komunikat_na_panel("                                                ",80,0);
	CALL SUBOPT_0xC3
	CALL SUBOPT_0xC4
	CALL _komunikat_na_panel
; 0000 179F      komunikat_na_panel("Wymien szczotke pedzelkowa",80,0);
	__POINTW1FN _0x0,1737
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xC4
	CALL _komunikat_na_panel
; 0000 17A0      }
; 0000 17A1 
; 0000 17A2 if(czas_pracy_krazka_sciernego_h >= czas_pracy_krazka_sciernego_stala)
_0x31F:
	CALL SUBOPT_0xB
	MOVW R0,R30
	CALL SUBOPT_0x1B
	CP   R0,R30
	CPC  R1,R31
	BRLT _0x320
; 0000 17A3      {
; 0000 17A4      PORT_F.bits.b6 = 1;
	LDS  R30,_PORT_F
	ORI  R30,0x40
	CALL SUBOPT_0x96
; 0000 17A5      PORTF = PORT_F.byte;
; 0000 17A6      komunikat_na_panel("                                                ",64,0);
	CALL SUBOPT_0xC3
	CALL SUBOPT_0xC5
	CALL _komunikat_na_panel
; 0000 17A7      komunikat_na_panel("Wymien krazek scierny",64,0);
	__POINTW1FN _0x0,1764
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xC5
	CALL _komunikat_na_panel
; 0000 17A8      }
; 0000 17A9 
; 0000 17AA 
; 0000 17AB }
_0x320:
	RET
;
;void wymiana_szczotki_i_krazka()
; 0000 17AE {
_wymiana_szczotki_i_krazka:
; 0000 17AF int g,e,f,d,cykl_wymiany;
; 0000 17B0 cykl_wymiany = 0;
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
; 0000 17B1                       //30 //20
; 0000 17B2 g = odczytaj_parametr(48,32);  //szczotka druciana
	CALL SUBOPT_0x11
	CALL SUBOPT_0x35
	CALL _odczytaj_parametr
	MOVW R16,R30
; 0000 17B3                     //30  //30
; 0000 17B4 f = odczytaj_parametr(48,48);  //krazek scierny
	CALL SUBOPT_0x11
	CALL SUBOPT_0x11
	CALL _odczytaj_parametr
	MOVW R20,R30
; 0000 17B5 
; 0000 17B6 while(g == 1)
_0x321:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BREQ PC+3
	JMP _0x323
; 0000 17B7     {
; 0000 17B8     switch(cykl_wymiany)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
; 0000 17B9     {
; 0000 17BA     case 0:
	SBIW R30,0
	BRNE _0x327
; 0000 17BB 
; 0000 17BC                cykl_sterownik_1 = 0;
	CALL SUBOPT_0xA2
; 0000 17BD                cykl_sterownik_2 = 0;
; 0000 17BE                cykl_sterownik_3 = 0;
; 0000 17BF                cykl_sterownik_4 = 0;
; 0000 17C0                cykl_wymiany = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 17C1 
; 0000 17C2 
; 0000 17C3 
; 0000 17C4     break;
	RJMP _0x326
; 0000 17C5 
; 0000 17C6     case 1:
_0x327:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x328
; 0000 17C7 
; 0000 17C8             //na sam dol zjezdzamy pionami
; 0000 17C9                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xA4
	SBIW R26,5
	BRGE _0x329
; 0000 17CA                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x24
	CALL SUBOPT_0xA5
; 0000 17CB                 if(cykl_sterownik_4 < 5)
_0x329:
	CALL SUBOPT_0xA6
	SBIW R26,5
	BRGE _0x32A
; 0000 17CC                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x89
	CALL SUBOPT_0xA7
; 0000 17CD 
; 0000 17CE                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x32A:
	CALL SUBOPT_0xA8
	BREQ _0x32B
; 0000 17CF 
; 0000 17D0                             {
; 0000 17D1                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xA9
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
_0x32B:
	RJMP _0x326
; 0000 17D9 
; 0000 17DA 
; 0000 17DB 
; 0000 17DC     case 2:
_0x328:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x32C
; 0000 17DD 
; 0000 17DE                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xAA
	SBIW R26,5
	BRGE _0x32D
; 0000 17DF                                     cykl_sterownik_1 = sterownik_1_praca(0x1F9);
	CALL SUBOPT_0xC6
	CALL SUBOPT_0xAB
; 0000 17E0                                  if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x32D:
	CALL SUBOPT_0xAC
	SBIW R26,5
	BRGE _0x32E
; 0000 17E1                                     cykl_sterownik_2 = sterownik_2_praca(0x1F9);       //ster 2 pod pin pozy rzad 1
	CALL SUBOPT_0xC6
	CALL SUBOPT_0xAE
; 0000 17E2 
; 0000 17E3                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x32E:
	CALL SUBOPT_0xAF
	BREQ _0x32F
; 0000 17E4                                         {
; 0000 17E5                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xA2
; 0000 17E6                                         cykl_sterownik_2 = 0;
; 0000 17E7                                         cykl_sterownik_3 = 0;
; 0000 17E8                                         cykl_sterownik_4 = 0;
; 0000 17E9                                          cykl_wymiany = 3;
	CALL SUBOPT_0xC7
; 0000 17EA 
; 0000 17EB                                         }
; 0000 17EC 
; 0000 17ED     break;
_0x32F:
	RJMP _0x326
; 0000 17EE 
; 0000 17EF 
; 0000 17F0 
; 0000 17F1     case 3:
_0x32C:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x330
; 0000 17F2 
; 0000 17F3             //na sam dol zjezdzamy pionami
; 0000 17F4                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xA4
	SBIW R26,5
	BRGE _0x331
; 0000 17F5                     cykl_sterownik_3 = sterownik_3_praca(0x02);  //do pozycji wymiany
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xB1
; 0000 17F6                 if(cykl_sterownik_4 < 5)
_0x331:
	CALL SUBOPT_0xA6
	SBIW R26,5
	BRGE _0x332
; 0000 17F7                     cykl_sterownik_4 = sterownik_4_praca(0x02,0);  //do pozycji wymiany
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xE
	CALL SUBOPT_0xA7
; 0000 17F8 
; 0000 17F9                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x332:
	CALL SUBOPT_0xA8
	BREQ _0x333
; 0000 17FA 
; 0000 17FB                             {
; 0000 17FC                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xA9
; 0000 17FD                                         cykl_sterownik_4 = 0;
; 0000 17FE                                         d = odczytaj_parametr(48,32);
	CALL SUBOPT_0x11
	CALL SUBOPT_0x35
	CALL _odczytaj_parametr
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 17FF 
; 0000 1800                                         switch (d)
; 0000 1801                                         {
; 0000 1802                                         case 0:
	SBIW R30,0
	BREQ _0x4A8
; 0000 1803 
; 0000 1804                                              cykl_wymiany = 4;
; 0000 1805                                              //jednak nie wymianiamy
; 0000 1806 
; 0000 1807                                         break;
; 0000 1808 
; 0000 1809                                         case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x338
; 0000 180A                                              cykl_wymiany = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP _0x4A9
; 0000 180B                                              //czekam z decyzja - w trakcie wymiany
; 0000 180C                                         break;
; 0000 180D 
; 0000 180E                                         case 2:
_0x338:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x336
; 0000 180F 
; 0000 1810                                              wymieniono_szczotke_druciana = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wymieniono_szczotke_druciana,R30
	STS  _wymieniono_szczotke_druciana+1,R31
; 0000 1811                                              PORT_F.bits.b6 = 0;   //zgas lampke
	LDS  R30,_PORT_F
	ANDI R30,0xBF
	CALL SUBOPT_0x96
; 0000 1812                                              PORTF = PORT_F.byte;
; 0000 1813                                              czas_pracy_szczotki_drucianej = 0;
	CALL SUBOPT_0x8
; 0000 1814                                              czas_pracy_szczotki_drucianej_h = 0;
	CALL SUBOPT_0x20
; 0000 1815                                              zaktualizuj_parametry_panelu();
	CALL _zaktualizuj_parametry_panelu
; 0000 1816                                              komunikat_na_panel("                                                ",80,0);
	CALL SUBOPT_0xC3
	CALL SUBOPT_0xC4
	CALL _komunikat_na_panel
; 0000 1817                                              cykl_wymiany = 4;
_0x4A8:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
_0x4A9:
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 1818                                              //wymianymy
; 0000 1819                                         break;
; 0000 181A                                         }
_0x336:
; 0000 181B                             }
; 0000 181C 
; 0000 181D 
; 0000 181E 
; 0000 181F 
; 0000 1820 
; 0000 1821 
; 0000 1822     break;
_0x333:
	RJMP _0x326
; 0000 1823 
; 0000 1824    case 4:
_0x330:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x326
; 0000 1825 
; 0000 1826                       //na sam dol zjezdzamy pionami
; 0000 1827                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xA4
	SBIW R26,5
	BRGE _0x33B
; 0000 1828                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x24
	CALL SUBOPT_0xA5
; 0000 1829                 if(cykl_sterownik_4 < 5)
_0x33B:
	CALL SUBOPT_0xA6
	SBIW R26,5
	BRGE _0x33C
; 0000 182A                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x89
	CALL SUBOPT_0xA7
; 0000 182B 
; 0000 182C                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x33C:
	CALL SUBOPT_0xA8
	BREQ _0x33D
; 0000 182D 
; 0000 182E                             {
; 0000 182F                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xA2
; 0000 1830                                         cykl_sterownik_2 = 0;
; 0000 1831                                         cykl_sterownik_3 = 0;
; 0000 1832                                         cykl_sterownik_4 = 0;
; 0000 1833                                         wartosc_parametru_panelu(0,48,32);
	CALL SUBOPT_0x24
	CALL SUBOPT_0x11
	CALL SUBOPT_0x35
	CALL _wartosc_parametru_panelu
; 0000 1834                                         cykl_wymiany = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 1835                                         g = 0;
	__GETWRN 16,17,0
; 0000 1836                                         }
; 0000 1837 
; 0000 1838    break;
_0x33D:
; 0000 1839 
; 0000 183A 
; 0000 183B     }//switch
_0x326:
; 0000 183C 
; 0000 183D    }//while
	RJMP _0x321
_0x323:
; 0000 183E 
; 0000 183F f = odczytaj_parametr(48,48);  //krazek scierny
	CALL SUBOPT_0x11
	CALL SUBOPT_0x11
	CALL _odczytaj_parametr
	MOVW R20,R30
; 0000 1840 cykl_wymiany = 0;
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
; 0000 1841 
; 0000 1842 while(f == 1)
_0x33E:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R20
	CPC  R31,R21
	BREQ PC+3
	JMP _0x340
; 0000 1843     {
; 0000 1844     switch(cykl_wymiany)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
; 0000 1845     {
; 0000 1846     case 0:
	SBIW R30,0
	BRNE _0x344
; 0000 1847 
; 0000 1848                cykl_sterownik_1 = 0;
	CALL SUBOPT_0xA2
; 0000 1849                cykl_sterownik_2 = 0;
; 0000 184A                cykl_sterownik_3 = 0;
; 0000 184B                cykl_sterownik_4 = 0;
; 0000 184C                cykl_wymiany = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 184D 
; 0000 184E 
; 0000 184F 
; 0000 1850     break;
	RJMP _0x343
; 0000 1851 
; 0000 1852     case 1:
_0x344:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x345
; 0000 1853 
; 0000 1854             //na sam dol zjezdzamy pionami
; 0000 1855                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xA4
	SBIW R26,5
	BRGE _0x346
; 0000 1856                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x24
	CALL SUBOPT_0xA5
; 0000 1857                 if(cykl_sterownik_4 < 5)
_0x346:
	CALL SUBOPT_0xA6
	SBIW R26,5
	BRGE _0x347
; 0000 1858                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x89
	CALL SUBOPT_0xA7
; 0000 1859 
; 0000 185A                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x347:
	CALL SUBOPT_0xA8
	BREQ _0x348
; 0000 185B 
; 0000 185C                             {
; 0000 185D                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xA9
; 0000 185E                                         cykl_sterownik_4 = 0;
; 0000 185F                                         cykl_wymiany = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 1860                                         }
; 0000 1861 
; 0000 1862 
; 0000 1863 
; 0000 1864     break;
_0x348:
	RJMP _0x343
; 0000 1865 
; 0000 1866 
; 0000 1867 
; 0000 1868     case 2:
_0x345:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x349
; 0000 1869 
; 0000 186A                                 if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xAA
	SBIW R26,5
	BRGE _0x34A
; 0000 186B                                     cykl_sterownik_1 = sterownik_1_praca(0x1F9);
	CALL SUBOPT_0xC6
	CALL SUBOPT_0xAB
; 0000 186C                                  if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x34A:
	CALL SUBOPT_0xAC
	SBIW R26,5
	BRGE _0x34B
; 0000 186D                                     cykl_sterownik_2 = sterownik_2_praca(0x1F9);       //ster 2 pod pin pozy rzad 1
	CALL SUBOPT_0xC6
	CALL SUBOPT_0xAE
; 0000 186E 
; 0000 186F                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x34B:
	CALL SUBOPT_0xAF
	BREQ _0x34C
; 0000 1870                                         {
; 0000 1871                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xA2
; 0000 1872                                         cykl_sterownik_2 = 0;
; 0000 1873                                         cykl_sterownik_3 = 0;
; 0000 1874                                         cykl_sterownik_4 = 0;
; 0000 1875                                          cykl_wymiany = 3;
	CALL SUBOPT_0xC7
; 0000 1876 
; 0000 1877                                         }
; 0000 1878 
; 0000 1879     break;
_0x34C:
	RJMP _0x343
; 0000 187A 
; 0000 187B 
; 0000 187C 
; 0000 187D     case 3:
_0x349:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x34D
; 0000 187E 
; 0000 187F             //na sam dol zjezdzamy pionami
; 0000 1880                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xA4
	SBIW R26,5
	BRGE _0x34E
; 0000 1881                     cykl_sterownik_3 = sterownik_3_praca(0x02);  //do pozycji wymiany
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xB1
; 0000 1882                 if(cykl_sterownik_4 < 5)
_0x34E:
	CALL SUBOPT_0xA6
	SBIW R26,5
	BRGE _0x34F
; 0000 1883                     cykl_sterownik_4 = sterownik_4_praca(0x02,0);  //do pozycji wymiany
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xE
	CALL SUBOPT_0xA7
; 0000 1884 
; 0000 1885                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x34F:
	CALL SUBOPT_0xA8
	BREQ _0x350
; 0000 1886 
; 0000 1887                             {
; 0000 1888                                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xA9
; 0000 1889                                         cykl_sterownik_4 = 0;
; 0000 188A                                         e = odczytaj_parametr(48,48);
	CALL SUBOPT_0x11
	CALL SUBOPT_0x11
	CALL _odczytaj_parametr
	MOVW R18,R30
; 0000 188B 
; 0000 188C                                         switch (e)
	MOVW R30,R18
; 0000 188D                                         {
; 0000 188E                                         case 0:
	SBIW R30,0
	BRNE _0x354
; 0000 188F 
; 0000 1890                                              cykl_wymiany = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 1891                                              //jednak nie wymianiamy
; 0000 1892 
; 0000 1893                                         break;
	RJMP _0x353
; 0000 1894 
; 0000 1895                                         case 1:
_0x354:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x355
; 0000 1896                                              cykl_wymiany = 3;
	CALL SUBOPT_0xC7
; 0000 1897                                              //czekam z decyzja - w trakcie wymiany
; 0000 1898                                         break;
	RJMP _0x353
; 0000 1899 
; 0000 189A                                         case 2:
_0x355:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x353
; 0000 189B                                              cykl_wymiany = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 189C                                              wymieniono_krazek_scierny = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wymieniono_krazek_scierny,R30
	STS  _wymieniono_krazek_scierny+1,R31
; 0000 189D                                              PORT_F.bits.b6 = 0;   //zgas lampke
	LDS  R30,_PORT_F
	ANDI R30,0xBF
	CALL SUBOPT_0x96
; 0000 189E                                              PORTF = PORT_F.byte;
; 0000 189F                                              czas_pracy_krazka_sciernego = 0;
	CALL SUBOPT_0xA
; 0000 18A0                                              czas_pracy_krazka_sciernego_h = 0;
	CALL SUBOPT_0x21
; 0000 18A1                                              zaktualizuj_parametry_panelu();
	CALL _zaktualizuj_parametry_panelu
; 0000 18A2                                              komunikat_na_panel("                                                ",64,0);
	CALL SUBOPT_0xC3
	CALL SUBOPT_0xC5
	CALL _komunikat_na_panel
; 0000 18A3                                              //wymianymy
; 0000 18A4                                         break;
; 0000 18A5                                         }
_0x353:
; 0000 18A6                             }
; 0000 18A7 
; 0000 18A8 
; 0000 18A9 
; 0000 18AA 
; 0000 18AB 
; 0000 18AC 
; 0000 18AD     break;
_0x350:
	RJMP _0x343
; 0000 18AE 
; 0000 18AF    case 4:
_0x34D:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x343
; 0000 18B0 
; 0000 18B1                       //na sam dol zjezdzamy pionami
; 0000 18B2                 if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xA4
	SBIW R26,5
	BRGE _0x358
; 0000 18B3                     cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x24
	CALL SUBOPT_0xA5
; 0000 18B4                 if(cykl_sterownik_4 < 5)
_0x358:
	CALL SUBOPT_0xA6
	SBIW R26,5
	BRGE _0x359
; 0000 18B5                     cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x89
	CALL SUBOPT_0xA7
; 0000 18B6 
; 0000 18B7                 if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x359:
	CALL SUBOPT_0xA8
	BREQ _0x35A
; 0000 18B8 
; 0000 18B9                             {
; 0000 18BA                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xA2
; 0000 18BB                                         cykl_sterownik_2 = 0;
; 0000 18BC                                         cykl_sterownik_3 = 0;
; 0000 18BD                                         cykl_sterownik_4 = 0;
; 0000 18BE                                         cykl_wymiany = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 18BF                                         wartosc_parametru_panelu(0,48,48);
	CALL SUBOPT_0x24
	CALL SUBOPT_0x11
	CALL SUBOPT_0x11
	CALL _wartosc_parametru_panelu
; 0000 18C0                                         f = 0;
	__GETWRN 20,21,0
; 0000 18C1                                         }
; 0000 18C2 
; 0000 18C3    break;
_0x35A:
; 0000 18C4 
; 0000 18C5 
; 0000 18C6     }//switch
_0x343:
; 0000 18C7 
; 0000 18C8    }//while
	RJMP _0x33E
_0x340:
; 0000 18C9 
; 0000 18CA 
; 0000 18CB 
; 0000 18CC 
; 0000 18CD 
; 0000 18CE 
; 0000 18CF 
; 0000 18D0 }
	CALL __LOADLOCR6
	ADIW R28,10
	RET
;
;
;
;
;
;void main(void)
; 0000 18D7 {
_main:
; 0000 18D8 
; 0000 18D9 // Input/Output Ports initialization
; 0000 18DA // Port A initialization
; 0000 18DB // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 18DC // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 18DD PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 18DE DDRA=0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 18DF 
; 0000 18E0 // Port B initialization
; 0000 18E1 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 18E2 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 18E3 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 18E4 DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 18E5 
; 0000 18E6 // Port C initialization
; 0000 18E7 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 18E8 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 18E9 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 18EA DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 18EB 
; 0000 18EC // Port D initialization
; 0000 18ED // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 18EE // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 18EF PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 18F0 DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 18F1 
; 0000 18F2 // Port E initialization
; 0000 18F3 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 18F4 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 18F5 PORTE=0x00;
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 18F6 DDRE=0xFF;
	LDI  R30,LOW(255)
	OUT  0x2,R30
; 0000 18F7 
; 0000 18F8 // Port F initialization
; 0000 18F9 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 18FA // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 18FB PORTF=0x00;
	LDI  R30,LOW(0)
	STS  98,R30
; 0000 18FC DDRF=0xFF;
	LDI  R30,LOW(255)
	STS  97,R30
; 0000 18FD 
; 0000 18FE // Port G initialization
; 0000 18FF // Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 1900 // State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 1901 PORTG=0x00;
	LDI  R30,LOW(0)
	STS  101,R30
; 0000 1902 DDRG=0x1F;
	LDI  R30,LOW(31)
	STS  100,R30
; 0000 1903 
; 0000 1904 
; 0000 1905 
; 0000 1906 
; 0000 1907 
; 0000 1908 // Timer/Counter 0 initialization
; 0000 1909 // Clock source: System Clock
; 0000 190A // Clock value: 15,625 kHz
; 0000 190B // Mode: Normal top=0xFF
; 0000 190C // OC0 output: Disconnected
; 0000 190D ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 190E TCCR0=0x07;
	LDI  R30,LOW(7)
	OUT  0x33,R30
; 0000 190F TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 1910 OCR0=0x00;
	OUT  0x31,R30
; 0000 1911 
; 0000 1912 // Timer/Counter 1 initialization
; 0000 1913 // Clock source: System Clock
; 0000 1914 // Clock value: Timer1 Stopped
; 0000 1915 // Mode: Normal top=0xFFFF
; 0000 1916 // OC1A output: Discon.
; 0000 1917 // OC1B output: Discon.
; 0000 1918 // OC1C output: Discon.
; 0000 1919 // Noise Canceler: Off
; 0000 191A // Input Capture on Falling Edge
; 0000 191B // Timer1 Overflow Interrupt: Off
; 0000 191C // Input Capture Interrupt: Off
; 0000 191D // Compare A Match Interrupt: Off
; 0000 191E // Compare B Match Interrupt: Off
; 0000 191F // Compare C Match Interrupt: Off
; 0000 1920 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 1921 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 1922 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 1923 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 1924 ICR1H=0x00;
	OUT  0x27,R30
; 0000 1925 ICR1L=0x00;
	OUT  0x26,R30
; 0000 1926 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 1927 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 1928 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 1929 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 192A OCR1CH=0x00;
	STS  121,R30
; 0000 192B OCR1CL=0x00;
	STS  120,R30
; 0000 192C 
; 0000 192D // Timer/Counter 2 initialization
; 0000 192E // Clock source: System Clock
; 0000 192F // Clock value: Timer2 Stopped
; 0000 1930 // Mode: Normal top=0xFF
; 0000 1931 // OC2 output: Disconnected
; 0000 1932 TCCR2=0x00;
	OUT  0x25,R30
; 0000 1933 TCNT2=0x00;
	OUT  0x24,R30
; 0000 1934 OCR2=0x00;
	OUT  0x23,R30
; 0000 1935 
; 0000 1936 // Timer/Counter 3 initialization
; 0000 1937 // Clock source: System Clock
; 0000 1938 // Clock value: Timer3 Stopped
; 0000 1939 // Mode: Normal top=0xFFFF
; 0000 193A // OC3A output: Discon.
; 0000 193B // OC3B output: Discon.
; 0000 193C // OC3C output: Discon.
; 0000 193D // Noise Canceler: Off
; 0000 193E // Input Capture on Falling Edge
; 0000 193F // Timer3 Overflow Interrupt: Off
; 0000 1940 // Input Capture Interrupt: Off
; 0000 1941 // Compare A Match Interrupt: Off
; 0000 1942 // Compare B Match Interrupt: Off
; 0000 1943 // Compare C Match Interrupt: Off
; 0000 1944 TCCR3A=0x00;
	STS  139,R30
; 0000 1945 TCCR3B=0x00;
	STS  138,R30
; 0000 1946 TCNT3H=0x00;
	STS  137,R30
; 0000 1947 TCNT3L=0x00;
	STS  136,R30
; 0000 1948 ICR3H=0x00;
	STS  129,R30
; 0000 1949 ICR3L=0x00;
	STS  128,R30
; 0000 194A OCR3AH=0x00;
	STS  135,R30
; 0000 194B OCR3AL=0x00;
	STS  134,R30
; 0000 194C OCR3BH=0x00;
	STS  133,R30
; 0000 194D OCR3BL=0x00;
	STS  132,R30
; 0000 194E OCR3CH=0x00;
	STS  131,R30
; 0000 194F OCR3CL=0x00;
	STS  130,R30
; 0000 1950 
; 0000 1951 // External Interrupt(s) initialization
; 0000 1952 // INT0: Off
; 0000 1953 // INT1: Off
; 0000 1954 // INT2: Off
; 0000 1955 // INT3: Off
; 0000 1956 // INT4: Off
; 0000 1957 // INT5: Off
; 0000 1958 // INT6: Off
; 0000 1959 // INT7: Off
; 0000 195A EICRA=0x00;
	STS  106,R30
; 0000 195B EICRB=0x00;
	OUT  0x3A,R30
; 0000 195C EIMSK=0x00;
	OUT  0x39,R30
; 0000 195D 
; 0000 195E // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 195F TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x37,R30
; 0000 1960 
; 0000 1961 ETIMSK=0x00;
	LDI  R30,LOW(0)
	STS  125,R30
; 0000 1962 
; 0000 1963 
; 0000 1964 // USART0 initialization
; 0000 1965 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 1966 // USART0 Receiver: On
; 0000 1967 // USART0 Transmitter: On
; 0000 1968 // USART0 Mode: Asynchronous
; 0000 1969 // USART0 Baud Rate: 115200
; 0000 196A UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	OUT  0xB,R30
; 0000 196B UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 196C UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 196D UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 196E UBRR0L=0x08;
	LDI  R30,LOW(8)
	OUT  0x9,R30
; 0000 196F 
; 0000 1970 // USART1 initialization
; 0000 1971 // USART1 disabled
; 0000 1972 UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (0<<RXEN1) | (0<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
	LDI  R30,LOW(0)
	STS  154,R30
; 0000 1973 
; 0000 1974 // Analog Comparator initialization
; 0000 1975 // Analog Comparator: Off
; 0000 1976 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 1977 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 1978 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 1979 
; 0000 197A // ADC initialization
; 0000 197B // ADC disabled
; 0000 197C ADCSRA=0x00;
	OUT  0x6,R30
; 0000 197D 
; 0000 197E // SPI initialization
; 0000 197F // SPI disabled
; 0000 1980 SPCR=0x00;
	OUT  0xD,R30
; 0000 1981 
; 0000 1982 // TWI initialization
; 0000 1983 // TWI disabled
; 0000 1984 TWCR=0x00;
	STS  116,R30
; 0000 1985 
; 0000 1986 //ciekawe, tej linijki brakowalo w medalach ,wyczailem w borgu
; 0000 1987 // I2C Bus initialization
; 0000 1988 i2c_init();
	CALL _i2c_init
; 0000 1989 
; 0000 198A // Global enable interrupts
; 0000 198B #asm("sei")
	sei
; 0000 198C 
; 0000 198D delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0xC8
; 0000 198E delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0xC8
; 0000 198F delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0xC8
; 0000 1990 delay_ms(2000); //bo panel sie inicjalizuje
	CALL SUBOPT_0xC8
; 0000 1991 
; 0000 1992 //jak patrze na maszyne to ten po lewej to 1
; 0000 1993 
; 0000 1994 putchar(90);  //5A
	CALL SUBOPT_0x2
; 0000 1995 putchar(165); //A5
; 0000 1996 putchar(3);//03  //znak dzwiekowy ze jestem
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _putchar
; 0000 1997 putchar(128);  //80
	LDI  R30,LOW(128)
	ST   -Y,R30
	CALL _putchar
; 0000 1998 putchar(2);    //02
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _putchar
; 0000 1999 putchar(16);   //10
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _putchar
; 0000 199A 
; 0000 199B il_prob_odczytu = 1;    //100
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
; 0000 199C start = 0;
	CLR  R12
	CLR  R13
; 0000 199D //szczotka_druciana_ilosc_cykli = 4; bo eeprom
; 0000 199E //krazek_scierny_cykl_po_okregu_ilosc = 4;
; 0000 199F //krazek_scierny_ilosc_cykli = 4;
; 0000 19A0 rzad_obrabiany = 1;
	CALL SUBOPT_0xC9
; 0000 19A1 jestem_w_trakcie_czyszczenia_calosci = 0;
	LDI  R30,LOW(0)
	STS  _jestem_w_trakcie_czyszczenia_calosci,R30
	STS  _jestem_w_trakcie_czyszczenia_calosci+1,R30
; 0000 19A2 wykonalem_rzedow = 0;
	CALL SUBOPT_0xCA
; 0000 19A3 cykl_ilosc_zaciskow = 0;
	CALL SUBOPT_0xCB
; 0000 19A4 guzik1_przelaczania_zaciskow = 1;
	SET
	BLD  R2,0
; 0000 19A5 guzik2_przelaczania_zaciskow = 1;
	BLD  R2,1
; 0000 19A6 PORTE.6 = 1;  //aby byl dostep do zaciskow rzad 1
	SBI  0x3,6
; 0000 19A7 zmienna_przelaczanie_zaciskow = 1;
	BLD  R2,2
; 0000 19A8 czas_przedmuchu = 183;
	LDI  R30,LOW(183)
	LDI  R31,HIGH(183)
	STS  _czas_przedmuchu,R30
	STS  _czas_przedmuchu+1,R31
; 0000 19A9 predkosc_pion_szczotka = 100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	STS  _predkosc_pion_szczotka,R30
	STS  _predkosc_pion_szczotka+1,R31
; 0000 19AA predkosc_pion_krazek = 100;
	STS  _predkosc_pion_krazek,R30
	STS  _predkosc_pion_krazek+1,R31
; 0000 19AB wejscie_krazka_sciernego_w_pow_boczna_cylindra = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wejscie_krazka_sciernego_w_pow_boczna_cylindra,R30
	STS  _wejscie_krazka_sciernego_w_pow_boczna_cylindra+1,R31
; 0000 19AC predkosc_ruchow_po_okregu_krazek_scierny = 50;
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _predkosc_ruchow_po_okregu_krazek_scierny,R30
	STS  _predkosc_ruchow_po_okregu_krazek_scierny+1,R31
; 0000 19AD 
; 0000 19AE adr1 = 80;  //rzad 1
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	STS  _adr1,R30
	STS  _adr1+1,R31
; 0000 19AF adr2 = 0;   //
	LDI  R30,LOW(0)
	STS  _adr2,R30
	STS  _adr2+1,R30
; 0000 19B0 adr3 = 64;  //rzad 2
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	STS  _adr3,R30
	STS  _adr3+1,R31
; 0000 19B1 adr4 = 0;
	LDI  R30,LOW(0)
	STS  _adr4,R30
	STS  _adr4+1,R30
; 0000 19B2 
; 0000 19B3 
; 0000 19B4 wartosci_wstepne_panelu();
	CALL _wartosci_wstepne_panelu
; 0000 19B5 wypozycjonuj_napedy_minimalistyczna();
	CALL _wypozycjonuj_napedy_minimalistyczna
; 0000 19B6 sprawdz_cisnienie();
	CALL _sprawdz_cisnienie
; 0000 19B7 
; 0000 19B8 //mniejsze ziarno na krazku - dobry pomysl
; 0000 19B9 
; 0000 19BA 
; 0000 19BB while (1)
_0x35D:
; 0000 19BC       {
; 0000 19BD       ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 19BE       przerzucanie_dociskow();
	CALL _przerzucanie_dociskow
; 0000 19BF       kontrola_zoltego_swiatla();
	RCALL _kontrola_zoltego_swiatla
; 0000 19C0       wymiana_szczotki_i_krazka();
	RCALL _wymiana_szczotki_i_krazka
; 0000 19C1       zaktualizuj_parametry_panelu();
	CALL _zaktualizuj_parametry_panelu
; 0000 19C2       odpytaj_parametry_panelu();
	CALL _odpytaj_parametry_panelu
; 0000 19C3       test_geometryczny();
	RCALL _test_geometryczny
; 0000 19C4       sprawdz_cisnienie();
	CALL _sprawdz_cisnienie
; 0000 19C5 
; 0000 19C6       while((start == 1 & il_zaciskow_rzad_1 > 1 & il_zaciskow_rzad_2 != 1 & macierz_zaciskow[1]!=0  & (macierz_zaciskow[2]!=0 |  il_zaciskow_rzad_2 == 0)) | jestem_w_trakcie_czyszczenia_calosci == 1)
_0x360:
	MOVW R26,R12
	CALL SUBOPT_0x7A
	MOV  R0,R30
	CALL SUBOPT_0xA0
	CALL SUBOPT_0xBD
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __NEW12
	AND  R0,R30
	CALL SUBOPT_0xA1
	MOV  R1,R30
	CALL SUBOPT_0xBF
	MOV  R0,R30
	CALL SUBOPT_0xBD
	CALL SUBOPT_0x8B
	OR   R30,R0
	AND  R30,R1
	MOV  R0,R30
	LDS  R26,_jestem_w_trakcie_czyszczenia_calosci
	LDS  R27,_jestem_w_trakcie_czyszczenia_calosci+1
	CALL SUBOPT_0x7A
	OR   R30,R0
	BRNE PC+3
	JMP _0x362
; 0000 19C7             {
; 0000 19C8             switch (cykl_glowny)
	LDS  R30,_cykl_glowny
	LDS  R31,_cykl_glowny+1
; 0000 19C9             {
; 0000 19CA             case 0:
	SBIW R30,0
	BREQ PC+3
	JMP _0x366
; 0000 19CB 
; 0000 19CC 
; 0000 19CD                     PORTB.6 = 1;   ////zielona lampka
	SBI  0x18,6
; 0000 19CE                     if(jestem_w_trakcie_czyszczenia_calosci == 0)
	LDS  R30,_jestem_w_trakcie_czyszczenia_calosci
	LDS  R31,_jestem_w_trakcie_czyszczenia_calosci+1
	SBIW R30,0
	BREQ PC+3
	JMP _0x369
; 0000 19CF                         {
; 0000 19D0                         wartosc_parametru_panelu(0,0,16);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x89
	CALL SUBOPT_0x2C
	CALL _wartosc_parametru_panelu
; 0000 19D1                         wartosc_parametru_panelu(0,0,96);  //wykonano zaciskow rzad2
	CALL SUBOPT_0x89
	CALL SUBOPT_0x2F
	CALL _wartosc_parametru_panelu
; 0000 19D2 
; 0000 19D3                         il_zaciskow_rzad_1 = odczytaj_parametr(0,128);
	CALL SUBOPT_0x24
	CALL SUBOPT_0x26
	CALL SUBOPT_0x27
; 0000 19D4                         il_zaciskow_rzad_2 = odczytaj_parametr(0,48);
	CALL SUBOPT_0x11
	CALL SUBOPT_0x28
; 0000 19D5 
; 0000 19D6                         szczotka_druciana_ilosc_cykli = odczytaj_parametr(48,64);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x25
	CALL SUBOPT_0x29
; 0000 19D7                                                 //2090
; 0000 19D8                         krazek_scierny_ilosc_cykli = odczytaj_parametr(32,144);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x2A
; 0000 19D9                                                     //3000
; 0000 19DA                         krazek_scierny_cykl_po_okregu_ilosc = odczytaj_parametr(48,0);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x2B
; 0000 19DB 
; 0000 19DC                         predkosc_pion_szczotka = odczytaj_parametr(32,80);
	CALL SUBOPT_0x35
	CALL SUBOPT_0x2E
	CALL _odczytaj_parametr
	STS  _predkosc_pion_szczotka,R30
	STS  _predkosc_pion_szczotka+1,R31
; 0000 19DD                                                 //2060
; 0000 19DE                         predkosc_pion_krazek = odczytaj_parametr(32,96);
	CALL SUBOPT_0x35
	CALL SUBOPT_0x2F
	CALL _odczytaj_parametr
	STS  _predkosc_pion_krazek,R30
	STS  _predkosc_pion_krazek+1,R31
; 0000 19DF 
; 0000 19E0                         wejscie_krazka_sciernego_w_pow_boczna_cylindra = odczytaj_parametr(48,16);
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	CALL SUBOPT_0x10
	CALL _odczytaj_parametr
	STS  _wejscie_krazka_sciernego_w_pow_boczna_cylindra,R30
	STS  _wejscie_krazka_sciernego_w_pow_boczna_cylindra+1,R31
; 0000 19E1 
; 0000 19E2                         predkosc_ruchow_po_okregu_krazek_scierny = odczytaj_parametr(32,112);
	CALL SUBOPT_0x35
	CALL SUBOPT_0x2D
	CALL _odczytaj_parametr
	STS  _predkosc_ruchow_po_okregu_krazek_scierny,R30
	STS  _predkosc_ruchow_po_okregu_krazek_scierny+1,R31
; 0000 19E3 
; 0000 19E4                         if(il_zaciskow_rzad_2 > 0 & macierz_zaciskow[2]!=0)
	CALL SUBOPT_0xCC
	MOV  R0,R30
	CALL SUBOPT_0xBF
	AND  R30,R0
	BREQ _0x36A
; 0000 19E5                               il_zaciskow_rzad_2 = il_zaciskow_rzad_2;
	CALL SUBOPT_0xCD
	STS  _il_zaciskow_rzad_2,R30
	STS  _il_zaciskow_rzad_2+1,R31
; 0000 19E6                         else
	RJMP _0x36B
_0x36A:
; 0000 19E7                               il_zaciskow_rzad_2 = 0;
	LDI  R30,LOW(0)
	STS  _il_zaciskow_rzad_2,R30
	STS  _il_zaciskow_rzad_2+1,R30
; 0000 19E8 
; 0000 19E9                         wybor_linijek_sterownikow(1);  //rzad 1
_0x36B:
	CALL SUBOPT_0xA3
	CALL _wybor_linijek_sterownikow
; 0000 19EA                         }
; 0000 19EB 
; 0000 19EC                     jestem_w_trakcie_czyszczenia_calosci = 1;
_0x369:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _jestem_w_trakcie_czyszczenia_calosci,R30
	STS  _jestem_w_trakcie_czyszczenia_calosci+1,R31
; 0000 19ED 
; 0000 19EE                     if(rzad_obrabiany == 1)
	CALL SUBOPT_0xCE
	SBIW R26,1
	BRNE _0x36C
; 0000 19EF                     {
; 0000 19F0                     PORTE.6 = 0;    //przelacz rzad zaciskow - rzad 1
	CBI  0x3,6
; 0000 19F1                     if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xAA
	SBIW R26,5
	BRGE _0x36F
; 0000 19F2                         cykl_sterownik_1 = sterownik_1_praca(0x009);
	CALL SUBOPT_0xC1
	CALL SUBOPT_0xAB
; 0000 19F3                     if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x36F:
	CALL SUBOPT_0xAC
	SBIW R26,5
	BRGE _0x370
; 0000 19F4                         cykl_sterownik_2 = sterownik_2_praca(0x000);       //ster 2 pod pin pozy rzad 1
	CALL SUBOPT_0x24
	CALL SUBOPT_0xAE
; 0000 19F5                     }
_0x370:
; 0000 19F6 
; 0000 19F7                     if(rzad_obrabiany == 2)
_0x36C:
	CALL SUBOPT_0xCE
	SBIW R26,2
	BRNE _0x371
; 0000 19F8                     {
; 0000 19F9                     ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 19FA                     //PORTE.6 = 1;    //przelacz rzad zaciskow - rzad 2 - na razie nie bo nie ma jeszcze oslon
; 0000 19FB 
; 0000 19FC                     if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xAA
	SBIW R26,5
	BRGE _0x372
; 0000 19FD                         cykl_sterownik_1 = sterownik_1_praca(0x008);
	CALL SUBOPT_0xAD
	CALL SUBOPT_0xAB
; 0000 19FE                     if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x372:
	CALL SUBOPT_0xAC
	SBIW R26,5
	BRGE _0x373
; 0000 19FF                         cykl_sterownik_2 = sterownik_2_praca(0x001);       //ster 2 pod pin pozy rzad 2
	CALL SUBOPT_0xA3
	CALL SUBOPT_0xAE
; 0000 1A00                     }
_0x373:
; 0000 1A01 
; 0000 1A02 
; 0000 1A03                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x371:
	CALL SUBOPT_0xAF
	BREQ _0x374
; 0000 1A04                         {
; 0000 1A05 
; 0000 1A06                           if(rzad_obrabiany == 2)
	CALL SUBOPT_0xCE
	SBIW R26,2
	BRNE _0x375
; 0000 1A07                             {
; 0000 1A08                             while(PORTE.6 == 0)
_0x376:
	SBIC 0x3,6
	RJMP _0x378
; 0000 1A09                                 przerzucanie_dociskow();
	CALL _przerzucanie_dociskow
	RJMP _0x376
_0x378:
; 0000 1A0A delay_ms(3000);
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 1A0B                             }
; 0000 1A0C 
; 0000 1A0D                         delay_ms(2000);  //aby zdazyl przelozyc
_0x375:
	CALL SUBOPT_0xC8
; 0000 1A0E                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xA2
; 0000 1A0F                         cykl_sterownik_2 = 0;
; 0000 1A10                         cykl_sterownik_3 = 0;
; 0000 1A11                         cykl_sterownik_4 = 0;
; 0000 1A12                         cykl_ilosc_zaciskow = 0;
	CALL SUBOPT_0xCB
; 0000 1A13                         koniec_rzedu_10 = 0;
	CALL SUBOPT_0xCF
; 0000 1A14                         if(rzad_obrabiany == 1)
	CALL SUBOPT_0xCE
	SBIW R26,1
	BRNE _0x379
; 0000 1A15                              {
; 0000 1A16                              while(sprawdz_pin0(PORTMM,0x77) == 1)
_0x37A:
	CALL SUBOPT_0x23
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BREQ _0x37A
; 0000 1A17                                 {
; 0000 1A18                                 }
; 0000 1A19 
; 0000 1A1A                             cykl_glowny = 1;
	CALL SUBOPT_0xD0
; 0000 1A1B                              }
; 0000 1A1C 
; 0000 1A1D                         if(rzad_obrabiany == 2)
_0x379:
	CALL SUBOPT_0xCE
	SBIW R26,2
	BRNE _0x37D
; 0000 1A1E                              {
; 0000 1A1F                              while(sprawdz_pin1(PORTMM,0x77) == 1)
_0x37E:
	CALL SUBOPT_0x23
	CALL _sprawdz_pin1
	CPI  R30,LOW(0x1)
	BREQ _0x37E
; 0000 1A20                                 {
; 0000 1A21                                 }
; 0000 1A22 
; 0000 1A23                             cykl_glowny = 1;
	CALL SUBOPT_0xD0
; 0000 1A24                              }
; 0000 1A25                         }
_0x37D:
; 0000 1A26 
; 0000 1A27             break;
_0x374:
	RJMP _0x365
; 0000 1A28 
; 0000 1A29 
; 0000 1A2A 
; 0000 1A2B             case 1:
_0x366:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x381
; 0000 1A2C 
; 0000 1A2D 
; 0000 1A2E                      if(cykl_sterownik_2 < 5 & rzad_obrabiany == 1)
	CALL SUBOPT_0xD1
	CALL SUBOPT_0x7A
	AND  R30,R0
	BREQ _0x382
; 0000 1A2F                           {          //ster 1 nic
; 0000 1A30                           PORTE.7 = 1;   //zacisnij zaciski
	SBI  0x3,7
; 0000 1A31                           cykl_sterownik_2 = sterownik_2_praca(a[0]);        //ster 2 pod zacisk
	CALL SUBOPT_0xB0
	CALL SUBOPT_0xAE
; 0000 1A32                           }                                                    //ster 4 na pozycje miedzy rzedzami
; 0000 1A33 
; 0000 1A34                      if(cykl_sterownik_2 < 5 & rzad_obrabiany == 2)
_0x382:
	CALL SUBOPT_0xD1
	CALL SUBOPT_0xD2
	BREQ _0x385
; 0000 1A35                         {
; 0000 1A36                         //cykl_sterownik_2 = sterownik_2_praca(0x5B,0);
; 0000 1A37                           PORTE.7 = 1;   //zacisnij zaciski
	SBI  0x3,7
; 0000 1A38                           ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1A39                           cykl_sterownik_2 = sterownik_2_praca(a[1]);
	CALL SUBOPT_0xC2
	CALL SUBOPT_0xAE
; 0000 1A3A                          }
; 0000 1A3B                      if(cykl_sterownik_4 < 5 & cykl_sterownik_2 == 5)
_0x385:
	CALL SUBOPT_0xD3
	CALL __LTW12
	CALL SUBOPT_0xD4
	AND  R30,R0
	BREQ _0x388
; 0000 1A3C                        // cykl_sterownik_4 = sterownik_4_praca(0,0,0,0,0,1);
; 0000 1A3D                         cykl_sterownik_4 = sterownik_4_praca(0x01,0);
	CALL SUBOPT_0xD5
	CALL SUBOPT_0xA7
; 0000 1A3E 
; 0000 1A3F                       if(cykl_sterownik_2 == 5 & cykl_sterownik_4 == 5)
_0x388:
	CALL SUBOPT_0xD6
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0xD3
	CALL __EQW12
	AND  R30,R0
	BREQ _0x389
; 0000 1A40                         {
; 0000 1A41                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD7
; 0000 1A42                         cykl_sterownik_2 = 0;
	CALL SUBOPT_0xD8
; 0000 1A43                         cykl_sterownik_4 = 0;
; 0000 1A44                         szczotka_druc_cykl = 0;
	CALL SUBOPT_0xD9
; 0000 1A45 
; 0000 1A46 
; 0000 1A47                         if(rzad_obrabiany == 1)
	CALL SUBOPT_0xCE
	SBIW R26,1
	BRNE _0x38A
; 0000 1A48                              {
; 0000 1A49                              while(sprawdz_pin0(PORTMM,0x77) == 1)
_0x38B:
	CALL SUBOPT_0x23
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BREQ _0x38B
; 0000 1A4A                                 {
; 0000 1A4B                                 }
; 0000 1A4C 
; 0000 1A4D                             cykl_glowny = 2;
	CALL SUBOPT_0xDA
; 0000 1A4E                              }
; 0000 1A4F 
; 0000 1A50                         if(rzad_obrabiany == 2)
_0x38A:
	CALL SUBOPT_0xCE
	SBIW R26,2
	BRNE _0x38E
; 0000 1A51                              {
; 0000 1A52                              while(sprawdz_pin1(PORTMM,0x77) == 1)
_0x38F:
	CALL SUBOPT_0x23
	CALL _sprawdz_pin1
	CPI  R30,LOW(0x1)
	BREQ _0x38F
; 0000 1A53                                 {
; 0000 1A54                                 }
; 0000 1A55 
; 0000 1A56                             cykl_glowny = 2;
	CALL SUBOPT_0xDA
; 0000 1A57                              }
; 0000 1A58                         }
_0x38E:
; 0000 1A59 
; 0000 1A5A 
; 0000 1A5B             break;
_0x389:
	RJMP _0x365
; 0000 1A5C 
; 0000 1A5D 
; 0000 1A5E             case 2:
_0x381:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x392
; 0000 1A5F                     if(rzad_obrabiany == 2)
	CALL SUBOPT_0xCE
	SBIW R26,2
	BRNE _0x393
; 0000 1A60                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1A61 
; 0000 1A62                     if(cykl_sterownik_4 < 5)
_0x393:
	CALL SUBOPT_0xA6
	SBIW R26,5
	BRGE _0x394
; 0000 1A63                         //cykl_sterownik_4 = sterownik_4_praca(1,0,0,0,1,0);
; 0000 1A64                           cykl_sterownik_4 = sterownik_4_praca(a[2],1);
	CALL SUBOPT_0xDB
	CALL SUBOPT_0xA7
; 0000 1A65                     if(cykl_sterownik_4 == 5)
_0x394:
	CALL SUBOPT_0xA6
	SBIW R26,5
	BRNE _0x395
; 0000 1A66                         {
; 0000 1A67                         PORTE.2 = 1;  //wlacz szlifierke
	SBI  0x3,2
; 0000 1A68                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0xDC
; 0000 1A69                         if(rzad_obrabiany == 1)
	CALL SUBOPT_0xCE
	SBIW R26,1
	BRNE _0x398
; 0000 1A6A                              {
; 0000 1A6B                              while(sprawdz_pin0(PORTMM,0x77) == 1)
_0x399:
	CALL SUBOPT_0x23
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BREQ _0x399
; 0000 1A6C                                 {
; 0000 1A6D                                 }
; 0000 1A6E 
; 0000 1A6F                             cykl_glowny = 3;
	CALL SUBOPT_0xDD
; 0000 1A70                              }
; 0000 1A71 
; 0000 1A72                         if(rzad_obrabiany == 2)
_0x398:
	CALL SUBOPT_0xCE
	SBIW R26,2
	BRNE _0x39C
; 0000 1A73                              {
; 0000 1A74                              while(sprawdz_pin1(PORTMM,0x77) == 1)
_0x39D:
	CALL SUBOPT_0x23
	CALL _sprawdz_pin1
	CPI  R30,LOW(0x1)
	BREQ _0x39D
; 0000 1A75                                 {
; 0000 1A76                                 }
; 0000 1A77 
; 0000 1A78                             cykl_glowny = 3;
	CALL SUBOPT_0xDD
; 0000 1A79                              }
; 0000 1A7A                         }
_0x39C:
; 0000 1A7B 
; 0000 1A7C             break;
_0x395:
	RJMP _0x365
; 0000 1A7D 
; 0000 1A7E 
; 0000 1A7F             case 3:
_0x392:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3A0
; 0000 1A80 
; 0000 1A81                      if(rzad_obrabiany == 2)
	CALL SUBOPT_0xCE
	SBIW R26,2
	BRNE _0x3A1
; 0000 1A82                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1A83 
; 0000 1A84                     if(cykl_sterownik_4 < 5)
_0x3A1:
	CALL SUBOPT_0xA6
	SBIW R26,5
	BRGE _0x3A2
; 0000 1A85                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV
	CALL SUBOPT_0x76
	CALL SUBOPT_0xE
	CALL SUBOPT_0xA7
; 0000 1A86 
; 0000 1A87                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli)
_0x3A2:
	CALL SUBOPT_0xD3
	CALL SUBOPT_0xDE
	CALL SUBOPT_0xDF
	CALL __LTW12
	AND  R30,R0
	BREQ _0x3A3
; 0000 1A88                         {
; 0000 1A89                         szczotka_druc_cykl++;
	CALL SUBOPT_0xE0
; 0000 1A8A                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0xDC
; 0000 1A8B 
; 0000 1A8C                         if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)
	CALL SUBOPT_0x1D
	CALL SUBOPT_0xDF
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x3A4
; 0000 1A8D                             {
; 0000 1A8E                             if(rzad_obrabiany == 1)
	CALL SUBOPT_0xCE
	SBIW R26,1
	BRNE _0x3A5
; 0000 1A8F                              {
; 0000 1A90                              while(sprawdz_pin0(PORTMM,0x77) == 1)
_0x3A6:
	CALL SUBOPT_0x23
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BREQ _0x3A6
; 0000 1A91                                 {
; 0000 1A92                                 }
; 0000 1A93 
; 0000 1A94                             cykl_glowny = 4;
	CALL SUBOPT_0xE1
; 0000 1A95                              }
; 0000 1A96 
; 0000 1A97                         if(rzad_obrabiany == 2)
_0x3A5:
	CALL SUBOPT_0xCE
	SBIW R26,2
	BRNE _0x3A9
; 0000 1A98                              {
; 0000 1A99                              while(sprawdz_pin1(PORTMM,0x77) == 1)
_0x3AA:
	CALL SUBOPT_0x23
	CALL _sprawdz_pin1
	CPI  R30,LOW(0x1)
	BREQ _0x3AA
; 0000 1A9A                                 {
; 0000 1A9B                                 }
; 0000 1A9C 
; 0000 1A9D                             cykl_glowny = 4;
	CALL SUBOPT_0xE1
; 0000 1A9E                              }
; 0000 1A9F                             }
_0x3A9:
; 0000 1AA0                         else
	RJMP _0x3AD
_0x3A4:
; 0000 1AA1                             {
; 0000 1AA2                             if(rzad_obrabiany == 1)
	CALL SUBOPT_0xCE
	SBIW R26,1
	BRNE _0x3AE
; 0000 1AA3                              {
; 0000 1AA4                              while(sprawdz_pin0(PORTMM,0x77) == 1)
_0x3AF:
	CALL SUBOPT_0x23
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BREQ _0x3AF
; 0000 1AA5                                 {
; 0000 1AA6                                 }
; 0000 1AA7 
; 0000 1AA8                             cykl_glowny = 2;
	CALL SUBOPT_0xDA
; 0000 1AA9                              }
; 0000 1AAA 
; 0000 1AAB                         if(rzad_obrabiany == 2)
_0x3AE:
	CALL SUBOPT_0xCE
	SBIW R26,2
	BRNE _0x3B2
; 0000 1AAC                              {
; 0000 1AAD                              while(sprawdz_pin1(PORTMM,0x77) == 1)
_0x3B3:
	CALL SUBOPT_0x23
	CALL _sprawdz_pin1
	CPI  R30,LOW(0x1)
	BREQ _0x3B3
; 0000 1AAE                                 {
; 0000 1AAF                                 }
; 0000 1AB0 
; 0000 1AB1                             cykl_glowny = 2;
	CALL SUBOPT_0xDA
; 0000 1AB2                              }
; 0000 1AB3 
; 0000 1AB4                             }
_0x3B2:
_0x3AD:
; 0000 1AB5                         }
; 0000 1AB6 
; 0000 1AB7 
; 0000 1AB8 
; 0000 1AB9             break;
_0x3A3:
	RJMP _0x365
; 0000 1ABA 
; 0000 1ABB             case 4:
_0x3A0:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x3B6
; 0000 1ABC 
; 0000 1ABD 
; 0000 1ABE                       if(rzad_obrabiany == 2)
	CALL SUBOPT_0xCE
	SBIW R26,2
	BRNE _0x3B7
; 0000 1ABF                             ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1AC0 
; 0000 1AC1                      if(cykl_sterownik_4 < 5)
_0x3B7:
	CALL SUBOPT_0xA6
	SBIW R26,5
	BRGE _0x3B8
; 0000 1AC2                         cykl_sterownik_4 = sterownik_4_praca(0x01,0);
	CALL SUBOPT_0xD5
	CALL SUBOPT_0xA7
; 0000 1AC3 
; 0000 1AC4                      if(cykl_sterownik_4 == 5)
_0x3B8:
	CALL SUBOPT_0xA6
	SBIW R26,5
	BRNE _0x3B9
; 0000 1AC5                         {
; 0000 1AC6                         PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1AC7                         cykl_sterownik_4 = 0;
	CALL SUBOPT_0xDC
; 0000 1AC8 
; 0000 1AC9 
; 0000 1ACA                         if(rzad_obrabiany == 1)
	CALL SUBOPT_0xCE
	SBIW R26,1
	BRNE _0x3BC
; 0000 1ACB                              {
; 0000 1ACC                              while(sprawdz_pin0(PORTMM,0x77) == 1)
_0x3BD:
	CALL SUBOPT_0x23
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BREQ _0x3BD
; 0000 1ACD                                 {
; 0000 1ACE                                 }
; 0000 1ACF                                ruch_zlozony = 0;
	CALL SUBOPT_0xE2
; 0000 1AD0                             cykl_glowny = 5;
; 0000 1AD1                              }
; 0000 1AD2 
; 0000 1AD3                         if(rzad_obrabiany == 2)
_0x3BC:
	CALL SUBOPT_0xCE
	SBIW R26,2
	BRNE _0x3C0
; 0000 1AD4                              {
; 0000 1AD5                              while(sprawdz_pin1(PORTMM,0x77) == 1)
_0x3C1:
	CALL SUBOPT_0x23
	CALL _sprawdz_pin1
	CPI  R30,LOW(0x1)
	BREQ _0x3C1
; 0000 1AD6                                 {
; 0000 1AD7                                 }
; 0000 1AD8                                ruch_zlozony = 0;
	CALL SUBOPT_0xE2
; 0000 1AD9                             cykl_glowny = 5;
; 0000 1ADA                              }
; 0000 1ADB 
; 0000 1ADC                         }
_0x3C0:
; 0000 1ADD 
; 0000 1ADE             break;
_0x3B9:
	RJMP _0x365
; 0000 1ADF 
; 0000 1AE0             case 5:
_0x3B6:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3C4
; 0000 1AE1 
; 0000 1AE2 
; 0000 1AE3                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 0 & rzad_obrabiany == 1)
	CALL SUBOPT_0xE3
	CALL SUBOPT_0xE4
	AND  R30,R0
	BREQ _0x3C5
; 0000 1AE4                         cykl_sterownik_1 = sterownik_1_praca(0x000);
	CALL SUBOPT_0x24
	CALL SUBOPT_0xAB
; 0000 1AE5                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 0 & rzad_obrabiany == 2)
_0x3C5:
	CALL SUBOPT_0xE3
	CALL SUBOPT_0xE5
	BREQ _0x3C6
; 0000 1AE6                         cykl_sterownik_1 = sterownik_1_praca(0x001);
	CALL SUBOPT_0xA3
	CALL SUBOPT_0xAB
; 0000 1AE7 
; 0000 1AE8                      if(rzad_obrabiany == 2)
_0x3C6:
	CALL SUBOPT_0xCE
	SBIW R26,2
	BRNE _0x3C7
; 0000 1AE9                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1AEA 
; 0000 1AEB                     if(cykl_sterownik_1 == 5 & ruch_zlozony == 0)
_0x3C7:
	CALL SUBOPT_0xE6
	CALL __EQW12
	CALL SUBOPT_0xE7
	CALL SUBOPT_0x8B
	AND  R30,R0
	BREQ _0x3C8
; 0000 1AEC                         {
; 0000 1AED                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD7
; 0000 1AEE                         ruch_zlozony = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _ruch_zlozony,R30
	STS  _ruch_zlozony+1,R31
; 0000 1AEF                         }
; 0000 1AF0 
; 0000 1AF1                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 1 & rzad_obrabiany == 1)
_0x3C8:
	CALL SUBOPT_0xE6
	CALL SUBOPT_0xE8
	CALL SUBOPT_0x7A
	CALL SUBOPT_0xE4
	AND  R30,R0
	BREQ _0x3C9
; 0000 1AF2                         //cykl_sterownik_1 = sterownik_1_praca(0x5A,0);
; 0000 1AF3                         cykl_sterownik_1 = sterownik_1_praca(a[0]);
	CALL SUBOPT_0xB0
	CALL SUBOPT_0xAB
; 0000 1AF4                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 1 & rzad_obrabiany == 2)
_0x3C9:
	CALL SUBOPT_0xE6
	CALL SUBOPT_0xE8
	CALL SUBOPT_0x7A
	CALL SUBOPT_0xE5
	BREQ _0x3CA
; 0000 1AF5                         //cykl_sterownik_1 = sterownik_1_praca(0x5B,0);
; 0000 1AF6                           cykl_sterownik_1 = sterownik_1_praca(a[1]);
	CALL SUBOPT_0xC2
	CALL SUBOPT_0xAB
; 0000 1AF7 
; 0000 1AF8 
; 0000 1AF9                     if(cykl_sterownik_1 < 5 & ruch_zlozony == 2)
_0x3CA:
	CALL SUBOPT_0xE6
	CALL SUBOPT_0xE8
	CALL SUBOPT_0xD2
	BREQ _0x3CB
; 0000 1AFA                         cykl_sterownik_1 = sterownik_1_praca(0x003);     ////////////////////////////////////////////////////////////
	CALL SUBOPT_0xBC
; 0000 1AFB 
; 0000 1AFC                     if(cykl_sterownik_2 < 5 & koniec_rzedu_10 == 0)                                //ster 1 do pierwszego dolka
_0x3CB:
	CALL SUBOPT_0xD6
	CALL SUBOPT_0xE9
	CALL SUBOPT_0x8B
	AND  R30,R0
	BREQ _0x3CC
; 0000 1AFD                         cykl_sterownik_2 = sterownik_2_praca(0x003);       //ster 2 pod nastpeny dolek
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0xEA
; 0000 1AFE 
; 0000 1AFF 
; 0000 1B00                     if(cykl_sterownik_2 < 5 & koniec_rzedu_10 == 1 & rzad_obrabiany == 1)
_0x3CC:
	CALL SUBOPT_0xD6
	CALL SUBOPT_0xE9
	CALL SUBOPT_0x7A
	CALL SUBOPT_0xE4
	AND  R30,R0
	BREQ _0x3CD
; 0000 1B01                         cykl_sterownik_2 = sterownik_2_praca(0x008);      //ster 2 do samego tylu
	CALL SUBOPT_0xAD
	CALL SUBOPT_0xAE
; 0000 1B02                      if(cykl_sterownik_2 < 5 & koniec_rzedu_10 == 1 & rzad_obrabiany == 2)
_0x3CD:
	CALL SUBOPT_0xD6
	CALL SUBOPT_0xE9
	CALL SUBOPT_0x7A
	CALL SUBOPT_0xE5
	BREQ _0x3CE
; 0000 1B03                         cykl_sterownik_2 = sterownik_2_praca(0x009);      //ster 2 do samego tylu
	CALL SUBOPT_0xC1
	CALL SUBOPT_0xAE
; 0000 1B04 
; 0000 1B05                     if((cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5 & ruch_zlozony == 1) | (cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5) & ruch_zlozony == 2)
_0x3CE:
	CALL SUBOPT_0xE6
	CALL __EQW12
	CALL SUBOPT_0xD4
	AND  R0,R30
	LDS  R26,_ruch_zlozony
	LDS  R27,_ruch_zlozony+1
	CALL SUBOPT_0x7A
	AND  R30,R0
	MOV  R1,R30
	CALL SUBOPT_0xE6
	CALL __EQW12
	CALL SUBOPT_0xD4
	AND  R0,R30
	LDS  R26,_ruch_zlozony
	LDS  R27,_ruch_zlozony+1
	CALL SUBOPT_0xD2
	OR   R30,R1
	BREQ _0x3CF
; 0000 1B06                         {
; 0000 1B07                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD7
; 0000 1B08                         cykl_sterownik_2 = 0;
	CALL SUBOPT_0xD8
; 0000 1B09                         cykl_sterownik_4 = 0;
; 0000 1B0A                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xEB
; 0000 1B0B                         if(rzad_obrabiany == 1)
	CALL SUBOPT_0xCE
	SBIW R26,1
	BRNE _0x3D0
; 0000 1B0C                              {
; 0000 1B0D                              while(sprawdz_pin0(PORTMM,0x77) == 1)
_0x3D1:
	CALL SUBOPT_0x23
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BREQ _0x3D1
; 0000 1B0E                                 {
; 0000 1B0F                                 }
; 0000 1B10                              PORTE.3 = 1;  //szlifierka 2 (krazek scierny)
	CALL SUBOPT_0xEC
; 0000 1B11                              cykl_glowny = 6;
; 0000 1B12                              }
; 0000 1B13 
; 0000 1B14                         if(rzad_obrabiany == 2)
_0x3D0:
	CALL SUBOPT_0xCE
	SBIW R26,2
	BRNE _0x3D6
; 0000 1B15                              {
; 0000 1B16                              while(sprawdz_pin1(PORTMM,0x77) == 1)
_0x3D7:
	CALL SUBOPT_0x23
	CALL _sprawdz_pin1
	CPI  R30,LOW(0x1)
	BREQ _0x3D7
; 0000 1B17                                 {
; 0000 1B18                                 }
; 0000 1B19                              PORTE.3 = 1;  //szlifierka 2 (krazek scierny)
	CALL SUBOPT_0xEC
; 0000 1B1A                              cykl_glowny = 6;
; 0000 1B1B                              }
; 0000 1B1C                         }
_0x3D6:
; 0000 1B1D 
; 0000 1B1E             break;
_0x3CF:
	RJMP _0x365
; 0000 1B1F 
; 0000 1B20 
; 0000 1B21             case 6:
_0x3C4:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3DC
; 0000 1B22 
; 0000 1B23 
; 0000 1B24 
; 0000 1B25 
; 0000 1B26                     if(cykl_sterownik_3 < 5)
	CALL SUBOPT_0xA4
	SBIW R26,5
	BRGE _0x3DD
; 0000 1B27                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //abs //krazek scierny do gory
	CALL SUBOPT_0x73
	CALL SUBOPT_0xB1
; 0000 1B28 
; 0000 1B29                     if(koniec_rzedu_10 == 1)
_0x3DD:
	LDS  R26,_koniec_rzedu_10
	LDS  R27,_koniec_rzedu_10+1
	SBIW R26,1
	BRNE _0x3DE
; 0000 1B2A                         cykl_sterownik_4 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x9B
; 0000 1B2B 
; 0000 1B2C                     if(cykl_sterownik_4 < 5)
_0x3DE:
	CALL SUBOPT_0xA6
	SBIW R26,5
	BRGE _0x3DF
; 0000 1B2D                         cykl_sterownik_4 = sterownik_4_praca(a[2],1);    //ABS          //druciak do gory
	CALL SUBOPT_0xDB
	CALL SUBOPT_0xA7
; 0000 1B2E 
; 0000 1B2F                      if(rzad_obrabiany == 2)
_0x3DF:
	CALL SUBOPT_0xCE
	SBIW R26,2
	BRNE _0x3E0
; 0000 1B30                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1B31 
; 0000 1B32 
; 0000 1B33                     if(cykl_sterownik_4 == 5 & cykl_sterownik_3 == 5)
_0x3E0:
	CALL SUBOPT_0xD3
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0xED
	CALL __EQW12
	AND  R30,R0
	BREQ _0x3E1
; 0000 1B34                         {
; 0000 1B35                         if((cykl_ilosc_zaciskow != il_zaciskow_rzad_1 - 1 & rzad_obrabiany == 1) | (cykl_ilosc_zaciskow != il_zaciskow_rzad_2 - 1 & rzad_obrabiany == 2))
	CALL SUBOPT_0xEE
	MOV  R0,R30
	CALL SUBOPT_0xCE
	CALL SUBOPT_0x7A
	AND  R30,R0
	MOV  R1,R30
	CALL SUBOPT_0xEF
	MOV  R0,R30
	CALL SUBOPT_0xCE
	CALL SUBOPT_0xD2
	OR   R30,R1
	BREQ _0x3E2
; 0000 1B36                             PORTE.2 = 1;  //wlacz szlifierke
	SBI  0x3,2
; 0000 1B37                         PORTB.4 = 1;  //przedmuch osi
_0x3E2:
	SBI  0x18,4
; 0000 1B38                         PORTE.3 = 1;  //szlifierka 2 (krazek scierny)
	SBI  0x3,3
; 0000 1B39                         cykl_sterownik_3 = 0;
	CALL SUBOPT_0xA9
; 0000 1B3A                         cykl_sterownik_4 = 0;
; 0000 1B3B                         if(cykl_ilosc_zaciskow > 0)
	CALL SUBOPT_0xF0
	CALL __CPW02
	BRGE _0x3E9
; 0000 1B3C                                 {
; 0000 1B3D                                 sek12 = 0;    //do przedmuchu
	CALL SUBOPT_0xF1
; 0000 1B3E                                 PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0xF2
; 0000 1B3F                                 PORTF = PORT_F.byte;
; 0000 1B40                                 }
; 0000 1B41                         if(rzad_obrabiany == 1)
_0x3E9:
	CALL SUBOPT_0xCE
	SBIW R26,1
	BRNE _0x3EA
; 0000 1B42                              {
; 0000 1B43                              while(sprawdz_pin0(PORTMM,0x77) == 1)
_0x3EB:
	CALL SUBOPT_0x23
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BREQ _0x3EB
; 0000 1B44                                 {
; 0000 1B45                                 }
; 0000 1B46                              cykl_glowny = 7;
	CALL SUBOPT_0xF3
; 0000 1B47                              }
; 0000 1B48 
; 0000 1B49                         if(rzad_obrabiany == 2)
_0x3EA:
	CALL SUBOPT_0xCE
	SBIW R26,2
	BRNE _0x3EE
; 0000 1B4A                              {
; 0000 1B4B                              while(sprawdz_pin1(PORTMM,0x77) == 1)
_0x3EF:
	CALL SUBOPT_0x23
	CALL _sprawdz_pin1
	CPI  R30,LOW(0x1)
	BREQ _0x3EF
; 0000 1B4C                                 {
; 0000 1B4D                                 }
; 0000 1B4E                              cykl_glowny = 7;
	CALL SUBOPT_0xF3
; 0000 1B4F                              }
; 0000 1B50                         }
_0x3EE:
; 0000 1B51 
; 0000 1B52            break;
_0x3E1:
	RJMP _0x365
; 0000 1B53 
; 0000 1B54 
; 0000 1B55            case 7:
_0x3DC:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3F2
; 0000 1B56                                                                                               //mini ruch do przygotowania do okregu
; 0000 1B57                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu_ilosc > 0 )
	CALL SUBOPT_0xE6
	CALL __LTW12
	MOV  R0,R30
	CALL SUBOPT_0x1F
	MOVW R26,R30
	CALL SUBOPT_0xBE
	AND  R30,R0
	BREQ _0x3F3
; 0000 1B58                           cykl_sterownik_1 = sterownik_1_praca(a[5]);
	CALL SUBOPT_0x74
	CALL SUBOPT_0xF4
; 0000 1B59 
; 0000 1B5A                      if(rzad_obrabiany == 2)
_0x3F3:
	CALL SUBOPT_0xCE
	SBIW R26,2
	BRNE _0x3F4
; 0000 1B5B                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1B5C 
; 0000 1B5D                     if(cykl_sterownik_1 == 5 | krazek_scierny_cykl_po_okregu_ilosc == 0)
_0x3F4:
	CALL SUBOPT_0xE6
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x1F
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	CALL __EQW12
	OR   R30,R0
	BREQ _0x3F5
; 0000 1B5E                         {
; 0000 1B5F 
; 0000 1B60                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD7
; 0000 1B61                         wykonalem_komplet_okregow = 0;
	LDI  R30,LOW(0)
	STS  _wykonalem_komplet_okregow,R30
	STS  _wykonalem_komplet_okregow+1,R30
; 0000 1B62 
; 0000 1B63                         if(krazek_scierny_cykl_po_okregu_ilosc == 0)
	CALL SUBOPT_0x1F
	SBIW R30,0
	BRNE _0x3F6
; 0000 1B64                             {
; 0000 1B65                             cykl_sterownik_1 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x92
; 0000 1B66                             wykonalem_komplet_okregow = 1;
	CALL SUBOPT_0xF5
; 0000 1B67                             }
; 0000 1B68 
; 0000 1B69                         szczotka_druc_cykl = 0;
_0x3F6:
	LDI  R30,LOW(0)
	CALL SUBOPT_0xD9
; 0000 1B6A                         krazek_scierny_cykl_po_okregu = 0;
	LDI  R30,LOW(0)
	STS  _krazek_scierny_cykl_po_okregu,R30
	STS  _krazek_scierny_cykl_po_okregu+1,R30
; 0000 1B6B 
; 0000 1B6C                         abs_ster3 = 0;
	STS  _abs_ster3,R30
	STS  _abs_ster3+1,R30
; 0000 1B6D                         abs_ster4 = 0;
	STS  _abs_ster4,R30
	STS  _abs_ster4+1,R30
; 0000 1B6E                         if(rzad_obrabiany == 1)
	CALL SUBOPT_0xCE
	SBIW R26,1
	BRNE _0x3F7
; 0000 1B6F                              {
; 0000 1B70                              while(sprawdz_pin0(PORTMM,0x77) == 1)
_0x3F8:
	CALL SUBOPT_0x23
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BREQ _0x3F8
; 0000 1B71                                 {
; 0000 1B72                                 }
; 0000 1B73                              cykl_glowny = 8;
	CALL SUBOPT_0xF6
; 0000 1B74                              }
; 0000 1B75 
; 0000 1B76                         if(rzad_obrabiany == 2)
_0x3F7:
	CALL SUBOPT_0xCE
	SBIW R26,2
	BRNE _0x3FB
; 0000 1B77                              {
; 0000 1B78                              while(sprawdz_pin1(PORTMM,0x77) == 1)
_0x3FC:
	CALL SUBOPT_0x23
	CALL _sprawdz_pin1
	CPI  R30,LOW(0x1)
	BREQ _0x3FC
; 0000 1B79                                 {
; 0000 1B7A                                 }
; 0000 1B7B                              cykl_glowny = 8;
	CALL SUBOPT_0xF6
; 0000 1B7C                              }
; 0000 1B7D                         }
_0x3FB:
; 0000 1B7E 
; 0000 1B7F 
; 0000 1B80 
; 0000 1B81            break;
_0x3F5:
	RJMP _0x365
; 0000 1B82 
; 0000 1B83 
; 0000 1B84             case 8:
_0x3F2:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x3FF
; 0000 1B85 
; 0000 1B86                     if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0xF7
	BRGE _0x400
; 0000 1B87                         {
; 0000 1B88                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0xF8
; 0000 1B89                         PORTF = PORT_F.byte;
; 0000 1B8A                         }
; 0000 1B8B 
; 0000 1B8C 
; 0000 1B8D                      if(rzad_obrabiany == 2)
_0x400:
	CALL SUBOPT_0xCE
	SBIW R26,2
	BRNE _0x401
; 0000 1B8E                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1B8F 
; 0000 1B90                     if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 0)
_0x401:
	CALL SUBOPT_0xE6
	CALL __LTW12
	MOV  R0,R30
	CALL SUBOPT_0x1F
	CALL SUBOPT_0xF9
	AND  R30,R0
	BREQ _0x402
; 0000 1B91                           cykl_sterownik_1 = sterownik_1_praca(a[6]);
	__GETW1MN _a,12
	CALL SUBOPT_0xF4
; 0000 1B92 
; 0000 1B93                     if(cykl_sterownik_1 == 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 0)
_0x402:
	CALL SUBOPT_0xE6
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x1F
	CALL SUBOPT_0xF9
	AND  R30,R0
	BREQ _0x403
; 0000 1B94                         {
; 0000 1B95                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD7
; 0000 1B96                         krazek_scierny_cykl_po_okregu++;
	LDI  R26,LOW(_krazek_scierny_cykl_po_okregu)
	LDI  R27,HIGH(_krazek_scierny_cykl_po_okregu)
	CALL SUBOPT_0xFA
; 0000 1B97                         }
; 0000 1B98 
; 0000 1B99                     if(krazek_scierny_cykl_po_okregu == krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 0)
_0x403:
	CALL SUBOPT_0x1F
	LDS  R26,_krazek_scierny_cykl_po_okregu
	LDS  R27,_krazek_scierny_cykl_po_okregu+1
	CALL SUBOPT_0xFB
	CALL SUBOPT_0x8B
	AND  R30,R0
	BREQ _0x404
; 0000 1B9A                         {
; 0000 1B9B                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD7
; 0000 1B9C                         wykonalem_komplet_okregow = 1;
	CALL SUBOPT_0xF5
; 0000 1B9D                         }
; 0000 1B9E 
; 0000 1B9F                     if(koniec_rzedu_10 == 1)
_0x404:
	LDS  R26,_koniec_rzedu_10
	LDS  R27,_koniec_rzedu_10+1
	SBIW R26,1
	BRNE _0x405
; 0000 1BA0                         cykl_sterownik_4 = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x9B
; 0000 1BA1                                                               //to nowy war, ostatni dzien w borg
; 0000 1BA2                     if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0)
_0x405:
	CALL SUBOPT_0xD3
	CALL SUBOPT_0xFC
	CALL SUBOPT_0x8B
	CALL SUBOPT_0xFD
	AND  R30,R0
	BREQ _0x406
; 0000 1BA3                          cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc
	CALL SUBOPT_0x76
	CALL SUBOPT_0xE
	CALL SUBOPT_0xA7
; 0000 1BA4 
; 0000 1BA5                     if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0)
_0x406:
	CALL SUBOPT_0xD3
	CALL SUBOPT_0xDE
	CALL SUBOPT_0xDF
	CALL __LTW12
	CALL SUBOPT_0xFD
	AND  R30,R0
	BREQ _0x407
; 0000 1BA6                         {
; 0000 1BA7                         if(koniec_rzedu_10 == 0)
	LDS  R30,_koniec_rzedu_10
	LDS  R31,_koniec_rzedu_10+1
	SBIW R30,0
	BRNE _0x408
; 0000 1BA8                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0xDC
; 0000 1BA9                         if(abs_ster4 == 0)
_0x408:
	LDS  R30,_abs_ster4
	LDS  R31,_abs_ster4+1
	SBIW R30,0
	BRNE _0x409
; 0000 1BAA                             {
; 0000 1BAB                             szczotka_druc_cykl++;
	CALL SUBOPT_0xE0
; 0000 1BAC                             abs_ster4 = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _abs_ster4,R30
	STS  _abs_ster4+1,R31
; 0000 1BAD                             }
; 0000 1BAE                         else
	RJMP _0x40A
_0x409:
; 0000 1BAF                             abs_ster4 = 0;
	LDI  R30,LOW(0)
	STS  _abs_ster4,R30
	STS  _abs_ster4+1,R30
; 0000 1BB0                         }
_0x40A:
; 0000 1BB1 
; 0000 1BB2                     if(cykl_sterownik_3 < 5 & abs_ster3 == 0)
_0x407:
	CALL SUBOPT_0xED
	CALL SUBOPT_0xFE
	CALL SUBOPT_0x8B
	AND  R30,R0
	BREQ _0x40B
; 0000 1BB3                          cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV
	__GETW1MN _a,14
	CALL SUBOPT_0xB1
; 0000 1BB4 
; 0000 1BB5 
; 0000 1BB6                     if(cykl_sterownik_3 == 5 & krazek_scierny_cykl < krazek_scierny_ilosc_cykli)
_0x40B:
	CALL SUBOPT_0xED
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x1E
	CALL SUBOPT_0xFF
	CALL __LTW12
	AND  R30,R0
	BREQ _0x40C
; 0000 1BB7                         {
; 0000 1BB8 
; 0000 1BB9                          cykl_sterownik_3 = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0xEB
; 0000 1BBA                         if(abs_ster3 == 0)
	LDS  R30,_abs_ster3
	LDS  R31,_abs_ster3+1
	SBIW R30,0
	BRNE _0x40D
; 0000 1BBB                             {
; 0000 1BBC                             krazek_scierny_cykl++;
	LDI  R26,LOW(_krazek_scierny_cykl)
	LDI  R27,HIGH(_krazek_scierny_cykl)
	CALL SUBOPT_0xFA
; 0000 1BBD                             abs_ster3 = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _abs_ster3,R30
	STS  _abs_ster3+1,R31
; 0000 1BBE                             }
; 0000 1BBF                         else
	RJMP _0x40E
_0x40D:
; 0000 1BC0                             abs_ster3 = 0;
	LDI  R30,LOW(0)
	STS  _abs_ster3,R30
	STS  _abs_ster3+1,R30
; 0000 1BC1                         }
_0x40E:
; 0000 1BC2 
; 0000 1BC3                     if(cykl_sterownik_3 < 5 & abs_ster3 == 1)
_0x40C:
	CALL SUBOPT_0xED
	CALL SUBOPT_0xFE
	CALL SUBOPT_0x7A
	AND  R30,R0
	BREQ _0x40F
; 0000 1BC4                         cykl_sterownik_3 = sterownik_3_praca(a[4]);  //ABS          //krazek scierny do gory
	CALL SUBOPT_0x73
	CALL SUBOPT_0xB1
; 0000 1BC5 
; 0000 1BC6                     if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0)
_0x40F:
	CALL SUBOPT_0xD3
	CALL SUBOPT_0xFC
	CALL SUBOPT_0x7A
	CALL SUBOPT_0xFD
	AND  R30,R0
	BREQ _0x410
; 0000 1BC7                         cykl_sterownik_4 = sterownik_4_praca(a[2],1);  //ABS          //druciak do gory
	CALL SUBOPT_0xDB
	CALL SUBOPT_0xA7
; 0000 1BC8 
; 0000 1BC9                                                                                            //mini ruch powrotny do okregu, zeby nie szorowal
; 0000 1BCA                     if(cykl_sterownik_1 < 5 & wykonalem_komplet_okregow == 1)
_0x410:
	CALL SUBOPT_0xE6
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	CALL SUBOPT_0x7A
	AND  R30,R0
	BREQ _0x411
; 0000 1BCB                          cykl_sterownik_1 = sterownik_1_praca(a[8]);
	__GETW1MN _a,16
	CALL SUBOPT_0xF4
; 0000 1BCC 
; 0000 1BCD                    ///////////////////////////////////////////////
; 0000 1BCE 
; 0000 1BCF                   if(cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & (wykonalem_komplet_okregow !=1 | krazek_scierny_cykl != krazek_scierny_ilosc_cykli))
_0x411:
	CALL SUBOPT_0xD3
	CALL SUBOPT_0xDE
	CALL SUBOPT_0xDF
	CALL __EQW12
	AND  R30,R0
	MOV  R1,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __NEW12
	MOV  R0,R30
	CALL SUBOPT_0x1E
	CALL SUBOPT_0xFF
	CALL __NEW12
	OR   R30,R0
	AND  R30,R1
	BREQ _0x412
; 0000 1BD0                        {
; 0000 1BD1                        cykl_sterownik_4 = 0;
	CALL SUBOPT_0xDC
; 0000 1BD2                        powrot_przedwczesny_druciak = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _powrot_przedwczesny_druciak,R30
	STS  _powrot_przedwczesny_druciak+1,R31
; 0000 1BD3                        }
; 0000 1BD4                   if(powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)
_0x412:
	CALL SUBOPT_0x100
	MOV  R0,R30
	CALL SUBOPT_0xD3
	CALL __LTW12
	AND  R30,R0
	BREQ _0x413
; 0000 1BD5                        cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0xD5
	CALL SUBOPT_0xA7
; 0000 1BD6 
; 0000 1BD7                   if(cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
_0x413:
	CALL SUBOPT_0xD3
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x100
	AND  R30,R0
	BREQ _0x414
; 0000 1BD8                        powrot_przedwczesny_druciak = 0;
	LDI  R30,LOW(0)
	STS  _powrot_przedwczesny_druciak,R30
	STS  _powrot_przedwczesny_druciak+1,R30
; 0000 1BD9                    //////////////////////////////////////////////
; 0000 1BDA 
; 0000 1BDB                     if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 1 &
_0x414:
; 0000 1BDC                        szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
; 0000 1BDD                        krazek_scierny_cykl == krazek_scierny_ilosc_cykli &
; 0000 1BDE                        cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 0)
	CALL SUBOPT_0xE6
	CALL SUBOPT_0xFB
	CALL SUBOPT_0x7A
	AND  R0,R30
	CALL SUBOPT_0x1D
	CALL SUBOPT_0xDF
	CALL __EQW12
	AND  R0,R30
	CALL SUBOPT_0x1E
	CALL SUBOPT_0xFF
	CALL __EQW12
	AND  R0,R30
	CALL SUBOPT_0xED
	CALL __EQW12
	AND  R0,R30
	CALL SUBOPT_0xD3
	CALL __EQW12
	CALL SUBOPT_0xFD
	AND  R30,R0
	BREQ _0x415
; 0000 1BDF                         {
; 0000 1BE0                         powrot_przedwczesny_druciak = 0;
	LDI  R30,LOW(0)
	STS  _powrot_przedwczesny_druciak,R30
	STS  _powrot_przedwczesny_druciak+1,R30
; 0000 1BE1                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xA2
; 0000 1BE2                         cykl_sterownik_2 = 0;
; 0000 1BE3                         cykl_sterownik_3 = 0;
; 0000 1BE4                         cykl_sterownik_4 = 0;
; 0000 1BE5                         szczotka_druc_cykl = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0xD9
; 0000 1BE6                         krazek_scierny_cykl = 0;
	LDI  R30,LOW(0)
	STS  _krazek_scierny_cykl,R30
	STS  _krazek_scierny_cykl+1,R30
; 0000 1BE7                         krazek_scierny_cykl_po_okregu = 0;
	STS  _krazek_scierny_cykl_po_okregu,R30
	STS  _krazek_scierny_cykl_po_okregu+1,R30
; 0000 1BE8                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
	CALL SUBOPT_0xF8
; 0000 1BE9                         PORTF = PORT_F.byte;
; 0000 1BEA 
; 0000 1BEB 
; 0000 1BEC                         if(rzad_obrabiany == 1)
	CALL SUBOPT_0xCE
	SBIW R26,1
	BRNE _0x416
; 0000 1BED                              {
; 0000 1BEE                              while(sprawdz_pin0(PORTMM,0x77) == 1)
_0x417:
	CALL SUBOPT_0x23
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BREQ _0x417
; 0000 1BEF                                 {
; 0000 1BF0                                 }
; 0000 1BF1                              cykl_glowny = 9;
	CALL SUBOPT_0x101
; 0000 1BF2                              }
; 0000 1BF3 
; 0000 1BF4                         if(rzad_obrabiany == 2)
_0x416:
	CALL SUBOPT_0xCE
	SBIW R26,2
	BRNE _0x41A
; 0000 1BF5                              {
; 0000 1BF6                              while(sprawdz_pin1(PORTMM,0x77) == 1)
_0x41B:
	CALL SUBOPT_0x23
	CALL _sprawdz_pin1
	CPI  R30,LOW(0x1)
	BREQ _0x41B
; 0000 1BF7                                 {
; 0000 1BF8                                 }
; 0000 1BF9                              cykl_glowny = 9;
	CALL SUBOPT_0x101
; 0000 1BFA                              }
; 0000 1BFB 
; 0000 1BFC 
; 0000 1BFD                         }
_0x41A:
; 0000 1BFE 
; 0000 1BFF                                                                                                 //ster 1 - ruch po okregu
; 0000 1C00                                                                                                 //ster 2 - nic
; 0000 1C01                                                                                                 //ster 3 - krazek - gora dol
; 0000 1C02                                                                                                 //ster 4 - druciak - gora dol
; 0000 1C03 
; 0000 1C04             break;
_0x415:
	RJMP _0x365
; 0000 1C05 
; 0000 1C06 
; 0000 1C07             case 9:                                          //cykl 3 == 5
_0x3FF:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x41E
; 0000 1C08 
; 0000 1C09 
; 0000 1C0A                          if(rzad_obrabiany == 1)
	CALL SUBOPT_0xCE
	SBIW R26,1
	BRNE _0x41F
; 0000 1C0B                          {
; 0000 1C0C                          if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow != il_zaciskow_rzad_1 - 1)
	CALL SUBOPT_0xED
	CALL __LTW12
	MOV  R0,R30
	CALL SUBOPT_0xEE
	AND  R30,R0
	BREQ _0x420
; 0000 1C0D                               cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0xA3
	CALL SUBOPT_0xA5
; 0000 1C0E 
; 0000 1C0F 
; 0000 1C10                           if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow < il_zaciskow_rzad_1 - 2)
_0x420:
	CALL SUBOPT_0xD3
	CALL SUBOPT_0x102
	CALL SUBOPT_0x103
	BREQ _0x421
; 0000 1C11                             cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0xD5
	CALL SUBOPT_0xA7
; 0000 1C12 
; 0000 1C13 
; 0000 1C14                          if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow == il_zaciskow_rzad_1 - 1)       //2 marca 2019 wykomentowuje
_0x421:
	CALL SUBOPT_0xED
	CALL SUBOPT_0x102
	CALL SUBOPT_0x104
	BREQ _0x422
; 0000 1C15                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x24
	CALL SUBOPT_0xA5
; 0000 1C16 
; 0000 1C17 
; 0000 1C18                          if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow >= il_zaciskow_rzad_1 - 2)
_0x422:
	CALL SUBOPT_0xD3
	CALL SUBOPT_0x102
	CALL SUBOPT_0x105
	BREQ _0x423
; 0000 1C19                             cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x89
	CALL SUBOPT_0xA7
; 0000 1C1A 
; 0000 1C1B                           }
_0x423:
; 0000 1C1C 
; 0000 1C1D 
; 0000 1C1E                          if(rzad_obrabiany == 2)
_0x41F:
	CALL SUBOPT_0xCE
	SBIW R26,2
	BRNE _0x424
; 0000 1C1F                          {
; 0000 1C20                          if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow != il_zaciskow_rzad_2 - 1)
	CALL SUBOPT_0xED
	CALL __LTW12
	MOV  R0,R30
	CALL SUBOPT_0xEF
	AND  R30,R0
	BREQ _0x425
; 0000 1C21                             cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
	CALL SUBOPT_0xA3
	CALL SUBOPT_0xA5
; 0000 1C22 
; 0000 1C23                           if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow < il_zaciskow_rzad_2 - 2)
_0x425:
	CALL SUBOPT_0xD3
	CALL SUBOPT_0x106
	CALL SUBOPT_0x103
	BREQ _0x426
; 0000 1C24                             cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
	CALL SUBOPT_0xD5
	CALL SUBOPT_0xA7
; 0000 1C25 
; 0000 1C26                          if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow == il_zaciskow_rzad_2 - 1)
_0x426:
	CALL SUBOPT_0xED
	CALL SUBOPT_0x106
	CALL SUBOPT_0x104
	BREQ _0x427
; 0000 1C27                             cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x24
	CALL SUBOPT_0xA5
; 0000 1C28 
; 0000 1C29 
; 0000 1C2A                           if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow >= il_zaciskow_rzad_2 - 2)
_0x427:
	CALL SUBOPT_0xD3
	CALL SUBOPT_0x106
	CALL SUBOPT_0x105
	BREQ _0x428
; 0000 1C2B                             cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
	CALL SUBOPT_0x89
	CALL SUBOPT_0xA7
; 0000 1C2C 
; 0000 1C2D                            if(rzad_obrabiany == 2)
_0x428:
	CALL SUBOPT_0xCE
	SBIW R26,2
	BRNE _0x429
; 0000 1C2E                             ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1C2F 
; 0000 1C30                           }
_0x429:
; 0000 1C31 
; 0000 1C32 
; 0000 1C33                           if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
_0x424:
	CALL SUBOPT_0xA8
	BREQ _0x42A
; 0000 1C34                             {
; 0000 1C35                             PORTE.2 = 0;  //wylacz szlifierke
	CBI  0x3,2
; 0000 1C36                             PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
	CBI  0x3,3
; 0000 1C37                             PORTB.4 = 0;  //wylacz przedmuchy
	CBI  0x18,4
; 0000 1C38                             cykl_sterownik_4 = 0;
	CALL SUBOPT_0xDC
; 0000 1C39                             cykl_sterownik_3 = 0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0xEB
; 0000 1C3A                             cykl_ilosc_zaciskow++;
	LDI  R26,LOW(_cykl_ilosc_zaciskow)
	LDI  R27,HIGH(_cykl_ilosc_zaciskow)
	CALL SUBOPT_0xFA
; 0000 1C3B                             ruch_zlozony = 2;                       //il_zaciskow_rzad_1
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _ruch_zlozony,R30
	STS  _ruch_zlozony+1,R31
; 0000 1C3C 
; 0000 1C3D 
; 0000 1C3E                             if(rzad_obrabiany == 1)
	CALL SUBOPT_0xCE
	SBIW R26,1
	BRNE _0x431
; 0000 1C3F                              {
; 0000 1C40                              while(sprawdz_pin0(PORTMM,0x77) == 1)
_0x432:
	CALL SUBOPT_0x23
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BREQ _0x432
; 0000 1C41                                 {
; 0000 1C42                                 }
; 0000 1C43                              cykl_glowny = 10;
	CALL SUBOPT_0x107
; 0000 1C44                              }
; 0000 1C45 
; 0000 1C46                         if(rzad_obrabiany == 2)
_0x431:
	CALL SUBOPT_0xCE
	SBIW R26,2
	BRNE _0x435
; 0000 1C47                              {
; 0000 1C48                              while(sprawdz_pin1(PORTMM,0x77) == 1)
_0x436:
	CALL SUBOPT_0x23
	CALL _sprawdz_pin1
	CPI  R30,LOW(0x1)
	BREQ _0x436
; 0000 1C49                                 {
; 0000 1C4A                                 }
; 0000 1C4B                              cykl_glowny = 10;
	CALL SUBOPT_0x107
; 0000 1C4C                              }
; 0000 1C4D 
; 0000 1C4E 
; 0000 1C4F                             }
_0x435:
; 0000 1C50 
; 0000 1C51 
; 0000 1C52             break;
_0x42A:
	RJMP _0x365
; 0000 1C53 
; 0000 1C54 
; 0000 1C55 
; 0000 1C56             case 10:
_0x41E:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x439
; 0000 1C57 
; 0000 1C58                                                //wywali ten warunek jak zadziala
; 0000 1C59                      if(rzad_obrabiany == 1 & cykl_glowny != 0)
	CALL SUBOPT_0xCE
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x108
	BREQ _0x43A
; 0000 1C5A                             {
; 0000 1C5B                             wartosc_parametru_panelu(cykl_ilosc_zaciskow,0,16);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x109
	CALL SUBOPT_0x2C
	CALL _wartosc_parametru_panelu
; 0000 1C5C                             if(cykl_ilosc_zaciskow <  il_zaciskow_rzad_1 - 1)
	CALL SUBOPT_0x10A
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x43B
; 0000 1C5D                                 {
; 0000 1C5E                                 cykl_glowny = 5;
	CALL SUBOPT_0x10B
; 0000 1C5F                                 koniec_rzedu_10 = 0;
	CALL SUBOPT_0xCF
; 0000 1C60                                 }
; 0000 1C61 
; 0000 1C62                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 - 1)
_0x43B:
	CALL SUBOPT_0x10A
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x43C
; 0000 1C63                                 {
; 0000 1C64                                 cykl_glowny = 5;
	CALL SUBOPT_0x10B
; 0000 1C65                                 koniec_rzedu_10 = 1;
	CALL SUBOPT_0x10C
; 0000 1C66                                 }
; 0000 1C67 
; 0000 1C68                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 & il_zaciskow_rzad_1 == 10)
_0x43C:
	CALL SUBOPT_0x10D
	CALL SUBOPT_0x7B
	BREQ _0x43D
; 0000 1C69                                 {
; 0000 1C6A                                 cykl_glowny = 11;
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CALL SUBOPT_0x10E
; 0000 1C6B                                 }
; 0000 1C6C 
; 0000 1C6D                              if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 & il_zaciskow_rzad_1 != 10)  /////zmieniam + 1 20.02
_0x43D:
	CALL SUBOPT_0x10D
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __NEW12
	AND  R30,R0
	BREQ _0x43E
; 0000 1C6E                                 {
; 0000 1C6F                                 cykl_glowny = 14;
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CALL SUBOPT_0x10E
; 0000 1C70                                 }
; 0000 1C71                             }
_0x43E:
; 0000 1C72 
; 0000 1C73 
; 0000 1C74                              if(rzad_obrabiany == 2)
_0x43A:
	CALL SUBOPT_0xCE
	SBIW R26,2
	BRNE _0x43F
; 0000 1C75                                 ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1C76 
; 0000 1C77                             if(rzad_obrabiany == 2 & cykl_glowny != 0)
_0x43F:
	CALL SUBOPT_0xCE
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	CALL SUBOPT_0x108
	BREQ _0x440
; 0000 1C78                             {
; 0000 1C79                             wartosc_parametru_panelu(cykl_ilosc_zaciskow,0,96);  //wykonano zaciskow rzad1
	CALL SUBOPT_0x109
	CALL SUBOPT_0x2F
	CALL _wartosc_parametru_panelu
; 0000 1C7A                             if(cykl_ilosc_zaciskow <  il_zaciskow_rzad_2 - 1)
	CALL SUBOPT_0xCD
	SBIW R30,1
	CALL SUBOPT_0xF0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x441
; 0000 1C7B                                 {
; 0000 1C7C                                 cykl_glowny = 5;
	CALL SUBOPT_0x10B
; 0000 1C7D                                 koniec_rzedu_10 = 0;
	CALL SUBOPT_0xCF
; 0000 1C7E                                 }
; 0000 1C7F 
; 0000 1C80                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 - 1)
_0x441:
	CALL SUBOPT_0xCD
	SBIW R30,1
	CALL SUBOPT_0xF0
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x442
; 0000 1C81                                 {
; 0000 1C82                                 cykl_glowny = 5;
	CALL SUBOPT_0x10B
; 0000 1C83                                 koniec_rzedu_10 = 1;
	CALL SUBOPT_0x10C
; 0000 1C84                                 }
; 0000 1C85 
; 0000 1C86                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 & il_zaciskow_rzad_2 == 10)
_0x442:
	CALL SUBOPT_0x10F
	CALL SUBOPT_0x7B
	BREQ _0x443
; 0000 1C87                                 {
; 0000 1C88                                 cykl_glowny = 12;
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CALL SUBOPT_0x10E
; 0000 1C89                                 }
; 0000 1C8A 
; 0000 1C8B 
; 0000 1C8C                              if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 & il_zaciskow_rzad_2 != 10)   ///////////////////zmieniam + 1 20.02
_0x443:
	CALL SUBOPT_0x10F
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __NEW12
	AND  R30,R0
	BREQ _0x444
; 0000 1C8D                                 {
; 0000 1C8E                                 cykl_glowny = 14;
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CALL SUBOPT_0x10E
; 0000 1C8F                                 }
; 0000 1C90                             }
_0x444:
; 0000 1C91 
; 0000 1C92 
; 0000 1C93 
; 0000 1C94             break;
_0x440:
	RJMP _0x365
; 0000 1C95 
; 0000 1C96 
; 0000 1C97 
; 0000 1C98             case 11:
_0x439:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x445
; 0000 1C99 
; 0000 1C9A                               if(rzad_obrabiany == 2)
	CALL SUBOPT_0xCE
	SBIW R26,2
	BRNE _0x446
; 0000 1C9B                                 ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1C9C 
; 0000 1C9D                              //ster 1 ucieka od szafy
; 0000 1C9E                              if(cykl_sterownik_1 < 5)
_0x446:
	CALL SUBOPT_0xAA
	SBIW R26,5
	BRGE _0x447
; 0000 1C9F                                     cykl_sterownik_1 = sterownik_1_praca(0x007);     //uciekamy do tylu
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0xF4
; 0000 1CA0 
; 0000 1CA1                              if(cykl_sterownik_2 < 5)
_0x447:
	CALL SUBOPT_0xAC
	SBIW R26,5
	BRGE _0x448
; 0000 1CA2                                     cykl_sterownik_2 = sterownik_2_praca(0x190);     //pod dolek ostatni 10 do przedmuchu rzad 1
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	CALL SUBOPT_0xEA
; 0000 1CA3 
; 0000 1CA4                              if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x448:
	CALL SUBOPT_0xAF
	BREQ _0x449
; 0000 1CA5                                     {
; 0000 1CA6                                     PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0xF2
; 0000 1CA7                                     PORTF = PORT_F.byte;
; 0000 1CA8                                     cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD7
; 0000 1CA9                                     cykl_sterownik_2 = 0;
	CALL SUBOPT_0x110
; 0000 1CAA 
; 0000 1CAB                                     if(rzad_obrabiany == 1)
	BRNE _0x44A
; 0000 1CAC                                     {
; 0000 1CAD                                         while(sprawdz_pin0(PORTMM,0x77) == 1)
_0x44B:
	CALL SUBOPT_0x23
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BREQ _0x44B
; 0000 1CAE                                             {
; 0000 1CAF                                             }
; 0000 1CB0                                     cykl_glowny = 13;
	CALL SUBOPT_0x111
; 0000 1CB1                                     }
; 0000 1CB2 
; 0000 1CB3                                     if(rzad_obrabiany == 2)
_0x44A:
	CALL SUBOPT_0xCE
	SBIW R26,2
	BRNE _0x44E
; 0000 1CB4                                     {
; 0000 1CB5                                     while(sprawdz_pin1(PORTMM,0x77) == 1)
_0x44F:
	CALL SUBOPT_0x23
	CALL _sprawdz_pin1
	CPI  R30,LOW(0x1)
	BREQ _0x44F
; 0000 1CB6                                         {
; 0000 1CB7                                         }
; 0000 1CB8                                         cykl_glowny = 13;
	CALL SUBOPT_0x111
; 0000 1CB9                                     }
; 0000 1CBA 
; 0000 1CBB 
; 0000 1CBC 
; 0000 1CBD 
; 0000 1CBE                                     }
_0x44E:
; 0000 1CBF             break;
_0x449:
	RJMP _0x365
; 0000 1CC0 
; 0000 1CC1 
; 0000 1CC2             case 12:
_0x445:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x452
; 0000 1CC3 
; 0000 1CC4                              if(rzad_obrabiany == 2)
	CALL SUBOPT_0xCE
	SBIW R26,2
	BRNE _0x453
; 0000 1CC5                                 ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1CC6 
; 0000 1CC7                                //ster 1 ucieka od szafy
; 0000 1CC8                              if(cykl_sterownik_1 < 5)
_0x453:
	CALL SUBOPT_0xAA
	SBIW R26,5
	BRGE _0x454
; 0000 1CC9                                     cykl_sterownik_1 = sterownik_1_praca(0x007);     //uciekamy do tylu
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0xF4
; 0000 1CCA 
; 0000 1CCB                             if(cykl_sterownik_2 < 5)
_0x454:
	CALL SUBOPT_0xAC
	SBIW R26,5
	BRGE _0x455
; 0000 1CCC                                     cykl_sterownik_2 = sterownik_2_praca(0x191);     //pod dolek ostatni 10 do przedmuchu rzad 2
	LDI  R30,LOW(401)
	LDI  R31,HIGH(401)
	CALL SUBOPT_0xEA
; 0000 1CCD 
; 0000 1CCE                              if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x455:
	CALL SUBOPT_0xAF
	BREQ _0x456
; 0000 1CCF                                     {
; 0000 1CD0                                     PORT_F.bits.b4 = 1;  //przedmuch zaciskow
	CALL SUBOPT_0xF2
; 0000 1CD1                                     PORTF = PORT_F.byte;
; 0000 1CD2                                     cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD7
; 0000 1CD3                                     cykl_sterownik_2 = 0;
	CALL SUBOPT_0x110
; 0000 1CD4 
; 0000 1CD5                                     if(rzad_obrabiany == 1)
	BRNE _0x457
; 0000 1CD6                                     {
; 0000 1CD7                                         while(sprawdz_pin0(PORTMM,0x77) == 1)
_0x458:
	CALL SUBOPT_0x23
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BREQ _0x458
; 0000 1CD8                                             {
; 0000 1CD9                                             }
; 0000 1CDA                                     cykl_glowny = 13;
	CALL SUBOPT_0x111
; 0000 1CDB                                     }
; 0000 1CDC 
; 0000 1CDD                                     if(rzad_obrabiany == 2)
_0x457:
	CALL SUBOPT_0xCE
	SBIW R26,2
	BRNE _0x45B
; 0000 1CDE                                     {
; 0000 1CDF                                     while(sprawdz_pin1(PORTMM,0x77) == 1)
_0x45C:
	CALL SUBOPT_0x23
	CALL _sprawdz_pin1
	CPI  R30,LOW(0x1)
	BREQ _0x45C
; 0000 1CE0                                         {
; 0000 1CE1                                         }
; 0000 1CE2                                         cykl_glowny = 13;
	CALL SUBOPT_0x111
; 0000 1CE3                                     }
; 0000 1CE4 
; 0000 1CE5 
; 0000 1CE6 
; 0000 1CE7                                     }
_0x45B:
; 0000 1CE8 
; 0000 1CE9 
; 0000 1CEA             break;
_0x456:
	RJMP _0x365
; 0000 1CEB 
; 0000 1CEC 
; 0000 1CED 
; 0000 1CEE             case 13:
_0x452:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x45F
; 0000 1CEF 
; 0000 1CF0 
; 0000 1CF1                               if(rzad_obrabiany == 2)
	CALL SUBOPT_0xCE
	SBIW R26,2
	BRNE _0x460
; 0000 1CF2                                 ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1CF3 
; 0000 1CF4                              if(cykl_sterownik_2 < 5)
_0x460:
	CALL SUBOPT_0xAC
	SBIW R26,5
	BRGE _0x461
; 0000 1CF5                                     cykl_sterownik_2 = sterownik_2_praca(0x192);     //okrag
	LDI  R30,LOW(402)
	LDI  R31,HIGH(402)
	CALL SUBOPT_0xEA
; 0000 1CF6                              if(cykl_sterownik_2 == 5)
_0x461:
	CALL SUBOPT_0xAC
	SBIW R26,5
	BRNE _0x462
; 0000 1CF7                                     {
; 0000 1CF8                                     PORT_F.bits.b4 = 0;  //przedmuch zaciskow - wylaczenie
	CALL SUBOPT_0xF8
; 0000 1CF9                                     PORTF = PORT_F.byte;
; 0000 1CFA                                     cykl_sterownik_2 = 0;
	CALL SUBOPT_0x110
; 0000 1CFB 
; 0000 1CFC 
; 0000 1CFD                                     if(rzad_obrabiany == 1)
	BRNE _0x463
; 0000 1CFE                                     {
; 0000 1CFF                                         while(sprawdz_pin0(PORTMM,0x77) == 1)
_0x464:
	CALL SUBOPT_0x23
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BREQ _0x464
; 0000 1D00                                             {
; 0000 1D01                                             }
; 0000 1D02                                     cykl_glowny = 16;
	CALL SUBOPT_0x112
; 0000 1D03                                     }
; 0000 1D04 
; 0000 1D05                                     if(rzad_obrabiany == 2)
_0x463:
	CALL SUBOPT_0xCE
	SBIW R26,2
	BRNE _0x467
; 0000 1D06                                     {
; 0000 1D07                                     while(sprawdz_pin1(PORTMM,0x77) == 1)
_0x468:
	CALL SUBOPT_0x23
	CALL _sprawdz_pin1
	CPI  R30,LOW(0x1)
	BREQ _0x468
; 0000 1D08                                         {
; 0000 1D09                                         }
; 0000 1D0A                                         cykl_glowny = 16;
	CALL SUBOPT_0x112
; 0000 1D0B                                     }
; 0000 1D0C 
; 0000 1D0D 
; 0000 1D0E 
; 0000 1D0F                                     }
_0x467:
; 0000 1D10 
; 0000 1D11             break;
_0x462:
	RJMP _0x365
; 0000 1D12 
; 0000 1D13 
; 0000 1D14 
; 0000 1D15             case 14:
_0x45F:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x46B
; 0000 1D16 
; 0000 1D17 
; 0000 1D18                      if(rzad_obrabiany == 2)
	CALL SUBOPT_0xCE
	SBIW R26,2
	BRNE _0x46C
; 0000 1D19                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1D1A 
; 0000 1D1B                     if(cykl_sterownik_1 < 5)
_0x46C:
	CALL SUBOPT_0xAA
	SBIW R26,5
	BRGE _0x46D
; 0000 1D1C                         cykl_sterownik_1 = sterownik_1_praca(0x003);     //pod nastepny dolek zeby przedmuchac
	CALL SUBOPT_0xBC
; 0000 1D1D                     if(cykl_sterownik_1 == 5)
_0x46D:
	CALL SUBOPT_0xAA
	SBIW R26,5
	BRNE _0x46E
; 0000 1D1E                         {
; 0000 1D1F                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xD7
; 0000 1D20                         sek12 = 0;
	CALL SUBOPT_0xF1
; 0000 1D21 
; 0000 1D22                         if(rzad_obrabiany == 1)
	CALL SUBOPT_0xCE
	SBIW R26,1
	BRNE _0x46F
; 0000 1D23                                     {
; 0000 1D24                                         while(sprawdz_pin0(PORTMM,0x77) == 1)
_0x470:
	CALL SUBOPT_0x23
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BREQ _0x470
; 0000 1D25                                             {
; 0000 1D26                                             }
; 0000 1D27                                     cykl_glowny = 15;
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CALL SUBOPT_0x10E
; 0000 1D28                                     }
; 0000 1D29 
; 0000 1D2A                                     if(rzad_obrabiany == 2)
_0x46F:
	CALL SUBOPT_0xCE
	SBIW R26,2
	BRNE _0x473
; 0000 1D2B                                     {
; 0000 1D2C                                     while(sprawdz_pin1(PORTMM,0x77) == 1)
_0x474:
	CALL SUBOPT_0x23
	CALL _sprawdz_pin1
	CPI  R30,LOW(0x1)
	BREQ _0x474
; 0000 1D2D                                         {
; 0000 1D2E                                         }
; 0000 1D2F                                         cykl_glowny = 15;
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CALL SUBOPT_0x10E
; 0000 1D30                                     }
; 0000 1D31 
; 0000 1D32 
; 0000 1D33 
; 0000 1D34 
; 0000 1D35 
; 0000 1D36                         }
_0x473:
; 0000 1D37 
; 0000 1D38             break;
_0x46E:
	RJMP _0x365
; 0000 1D39 
; 0000 1D3A 
; 0000 1D3B 
; 0000 1D3C             case 15:
_0x46B:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x477
; 0000 1D3D 
; 0000 1D3E                      if(rzad_obrabiany == 2)
	CALL SUBOPT_0xCE
	SBIW R26,2
	BRNE _0x478
; 0000 1D3F                         ostateczny_wybor_zacisku();
	CALL _ostateczny_wybor_zacisku
; 0000 1D40 
; 0000 1D41                     //przedmuch
; 0000 1D42                     PORT_F.bits.b4 = 1;  //przedmuch zaciskow
_0x478:
	CALL SUBOPT_0xF2
; 0000 1D43                     PORTF = PORT_F.byte;
; 0000 1D44                     if(sek12 > czas_przedmuchu)
	CALL SUBOPT_0xF7
	BRGE _0x479
; 0000 1D45                         {
; 0000 1D46                         PORT_F.bits.b4 = 0;  //przedmuch zaciskow
	CALL SUBOPT_0xF8
; 0000 1D47                         PORTF = PORT_F.byte;
; 0000 1D48 
; 0000 1D49                         if(rzad_obrabiany == 1)
	CALL SUBOPT_0xCE
	SBIW R26,1
	BRNE _0x47A
; 0000 1D4A                                     {
; 0000 1D4B                                         while(sprawdz_pin0(PORTMM,0x77) == 1)
_0x47B:
	CALL SUBOPT_0x23
	CALL _sprawdz_pin0
	CPI  R30,LOW(0x1)
	BREQ _0x47B
; 0000 1D4C                                             {
; 0000 1D4D                                             }
; 0000 1D4E                                     cykl_glowny = 16;
	CALL SUBOPT_0x112
; 0000 1D4F                                     }
; 0000 1D50 
; 0000 1D51                                     if(rzad_obrabiany == 2)
_0x47A:
	CALL SUBOPT_0xCE
	SBIW R26,2
	BRNE _0x47E
; 0000 1D52                                     {
; 0000 1D53                                     while(sprawdz_pin1(PORTMM,0x77) == 1)
_0x47F:
	CALL SUBOPT_0x23
	CALL _sprawdz_pin1
	CPI  R30,LOW(0x1)
	BREQ _0x47F
; 0000 1D54                                         {
; 0000 1D55                                         }
; 0000 1D56                                         cykl_glowny = 16;
	CALL SUBOPT_0x112
; 0000 1D57                                     }
; 0000 1D58 
; 0000 1D59 
; 0000 1D5A 
; 0000 1D5B 
; 0000 1D5C                         }
_0x47E:
; 0000 1D5D             break;
_0x479:
	RJMP _0x365
; 0000 1D5E 
; 0000 1D5F 
; 0000 1D60             case 16:
_0x477:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x482
; 0000 1D61 
; 0000 1D62                      if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 & wykonalem_rzedow == 0)  /////zmieniam + 1 20.02
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	CALL SUBOPT_0xF0
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0x113
	CALL SUBOPT_0x8B
	AND  R30,R0
	BREQ _0x483
; 0000 1D63                                 {
; 0000 1D64                                 cykl_ilosc_zaciskow = 0;
	CALL SUBOPT_0xCB
; 0000 1D65                                 PORTE.7 = 0;   //pusc zaciski
	CBI  0x3,7
; 0000 1D66                                 if(il_zaciskow_rzad_2 > 0)
	CALL SUBOPT_0xBD
	CALL __CPW02
	BRGE _0x486
; 0000 1D67                                     {
; 0000 1D68 
; 0000 1D69                                     rzad_obrabiany = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _rzad_obrabiany,R30
	STS  _rzad_obrabiany+1,R31
; 0000 1D6A                                     wybor_linijek_sterownikow(2);  //rzad 2
	CALL SUBOPT_0xC0
; 0000 1D6B                                     cykl_glowny = 0;
	LDI  R30,LOW(0)
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R30
; 0000 1D6C                                     }
; 0000 1D6D                                 else
	RJMP _0x487
_0x486:
; 0000 1D6E                                     cykl_glowny = 17;
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	CALL SUBOPT_0x10E
; 0000 1D6F 
; 0000 1D70                                 wykonalem_rzedow = 1;
_0x487:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wykonalem_rzedow,R30
	STS  _wykonalem_rzedow+1,R31
; 0000 1D71                                 }
; 0000 1D72 
; 0000 1D73                        if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 & il_zaciskow_rzad_2 > 0 & wykonalem_rzedow == 1)   ///////////////////zmieniam + 1 20.02
_0x483:
	CALL SUBOPT_0xCD
	CALL SUBOPT_0xF0
	CALL __EQW12
	MOV  R0,R30
	CALL SUBOPT_0xCC
	AND  R0,R30
	CALL SUBOPT_0x113
	CALL SUBOPT_0x7A
	AND  R30,R0
	BREQ _0x488
; 0000 1D74                                 {
; 0000 1D75                                 PORTE.7 = 0;   //pusc zaciski
	CBI  0x3,7
; 0000 1D76                                 cykl_ilosc_zaciskow = 0;
	CALL SUBOPT_0xCB
; 0000 1D77                                 cykl_glowny = 17;
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	CALL SUBOPT_0x10E
; 0000 1D78                                 rzad_obrabiany = 1;
	CALL SUBOPT_0xC9
; 0000 1D79                                 wykonalem_rzedow = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _wykonalem_rzedow,R30
	STS  _wykonalem_rzedow+1,R31
; 0000 1D7A                                 }
; 0000 1D7B 
; 0000 1D7C 
; 0000 1D7D 
; 0000 1D7E 
; 0000 1D7F                         if(il_zaciskow_rzad_1 > 0 & il_zaciskow_rzad_2 > 0 & wykonalem_rzedow == 2)
_0x488:
	CALL SUBOPT_0x114
	MOV  R0,R30
	CALL SUBOPT_0xCC
	AND  R0,R30
	CALL SUBOPT_0x113
	CALL SUBOPT_0xD2
	BREQ _0x48B
; 0000 1D80                                   {
; 0000 1D81                                   rzad_obrabiany = 1;
	CALL SUBOPT_0xC9
; 0000 1D82                                   wykonalem_rzedow = 0;
	CALL SUBOPT_0xCA
; 0000 1D83                                   PORTE.7 = 0;   //pusc zaciski
	CBI  0x3,7
; 0000 1D84                                   //PORTE.6 = 0;    //przelacz rzad zaciskow - rzad 1 - tego na razie nie poki nie ma oslon
; 0000 1D85                                   PORTB.6 = 0;   ////zielona lampka
	CBI  0x18,6
; 0000 1D86                                   wartosc_parametru_panelu(0,0,64);
	CALL SUBOPT_0x89
	CALL SUBOPT_0x7C
; 0000 1D87                                   }
; 0000 1D88 
; 0000 1D89                             if(il_zaciskow_rzad_1 > 0 & il_zaciskow_rzad_2 == 0 & wykonalem_rzedow == 1)
_0x48B:
	CALL SUBOPT_0x114
	MOV  R0,R30
	CALL SUBOPT_0xBD
	CALL SUBOPT_0x8B
	AND  R0,R30
	CALL SUBOPT_0x113
	CALL SUBOPT_0x7A
	AND  R30,R0
	BREQ _0x490
; 0000 1D8A                                   {
; 0000 1D8B                                   rzad_obrabiany = 1;
	CALL SUBOPT_0xC9
; 0000 1D8C                                   wykonalem_rzedow = 0;
	CALL SUBOPT_0xCA
; 0000 1D8D                                   PORTE.6 = 1;    //przelacz rzad zaciskow - rzad 2
	SBI  0x3,6
; 0000 1D8E                                   PORTB.6 = 0;   ////zielona lampka
	CBI  0x18,6
; 0000 1D8F                                   wartosc_parametru_panelu(0,0,64);
	CALL SUBOPT_0x89
	CALL SUBOPT_0x7C
; 0000 1D90                                   }
; 0000 1D91 
; 0000 1D92 
; 0000 1D93 
; 0000 1D94             break;
_0x490:
	RJMP _0x365
; 0000 1D95 
; 0000 1D96 
; 0000 1D97             case 17:
_0x482:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0x365
; 0000 1D98 
; 0000 1D99 
; 0000 1D9A                                  if(cykl_sterownik_1 < 5)
	CALL SUBOPT_0xAA
	SBIW R26,5
	BRGE _0x496
; 0000 1D9B                                     cykl_sterownik_1 = sterownik_1_praca(0x009);
	CALL SUBOPT_0xC1
	CALL SUBOPT_0xAB
; 0000 1D9C                                  if(cykl_sterownik_2 < 5)                                //ster 1 do 0
_0x496:
	CALL SUBOPT_0xAC
	SBIW R26,5
	BRGE _0x497
; 0000 1D9D                                     cykl_sterownik_2 = sterownik_2_praca(0x000);       //ster 2 pod pin pozy rzad 1
	CALL SUBOPT_0x24
	CALL SUBOPT_0xAE
; 0000 1D9E 
; 0000 1D9F                                     if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
_0x497:
	CALL SUBOPT_0xAF
	BREQ _0x498
; 0000 1DA0                                         {
; 0000 1DA1                                         cykl_sterownik_1 = 0;
	CALL SUBOPT_0xA2
; 0000 1DA2                                         cykl_sterownik_2 = 0;
; 0000 1DA3                                         cykl_sterownik_3 = 0;
; 0000 1DA4                                         cykl_sterownik_4 = 0;
; 0000 1DA5                                         jestem_w_trakcie_czyszczenia_calosci = 0;
	LDI  R30,LOW(0)
	STS  _jestem_w_trakcie_czyszczenia_calosci,R30
	STS  _jestem_w_trakcie_czyszczenia_calosci+1,R30
; 0000 1DA6                                         start = 0;
	CLR  R12
	CLR  R13
; 0000 1DA7                                         cykl_glowny = 0;
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R30
; 0000 1DA8                                         }
; 0000 1DA9 
; 0000 1DAA 
; 0000 1DAB 
; 0000 1DAC 
; 0000 1DAD             break;
_0x498:
; 0000 1DAE 
; 0000 1DAF 
; 0000 1DB0 
; 0000 1DB1             }//switch
_0x365:
; 0000 1DB2 
; 0000 1DB3 
; 0000 1DB4   }//while
	RJMP _0x360
_0x362:
; 0000 1DB5 }//while glowny
	RJMP _0x35D
; 0000 1DB6 
; 0000 1DB7 }//koniec
_0x499:
	RJMP _0x499
;
;
;
;
;/*
;case 0:
;
;
;                    PORTB.6 = 1;   ////zielona lampka
;                    if(jestem_w_trakcie_czyszczenia_calosci == 0)
;                        {
;                        wartosc_parametru_panelu(0,0,16);  //wykonano zaciskow rzad1
;                        wartosc_parametru_panelu(0,0,96);  //wykonano zaciskow rzad2
;
;                        il_zaciskow_rzad_1 = odczytaj_parametr(0,128);
;                        il_zaciskow_rzad_2 = odczytaj_parametr(0,48);
;
;                        szczotka_druciana_ilosc_cykli = odczytaj_parametr(48,64);
;                                                //2090
;                        krazek_scierny_ilosc_cykli = odczytaj_parametr(32,144);
;                                                    //3000
;                        krazek_scierny_cykl_po_okregu_ilosc = odczytaj_parametr(48,0);
;
;                        predkosc_pion_szczotka = odczytaj_parametr(32,80);
;                                                //2060
;                        predkosc_pion_krazek = odczytaj_parametr(32,96);
;
;                        wejscie_krazka_sciernego_w_pow_boczna_cylindra = odczytaj_parametr(48,16);
;
;                        predkosc_ruchow_po_okregu_krazek_scierny = odczytaj_parametr(32,112);
;
;                        if(il_zaciskow_rzad_2 > 0 & macierz_zaciskow[2]!=0)
;                              il_zaciskow_rzad_2 = il_zaciskow_rzad_2;
;                        else
;                              il_zaciskow_rzad_2 = 0;
;
;                        wybor_linijek_sterownikow(1);  //rzad 1
;                        }
;
;                    jestem_w_trakcie_czyszczenia_calosci = 1;
;
;                    if(rzad_obrabiany == 1)
;                    {
;                    PORTE.6 = 0;    //przelacz rzad zaciskow - rzad 1
;                    if(cykl_sterownik_1 < 5)
;                        cykl_sterownik_1 = sterownik_1_praca(0x009);
;                    if(cykl_sterownik_2 < 5)                                //ster 1 do 0
;                        cykl_sterownik_2 = sterownik_2_praca(0x000);       //ster 2 pod pin pozy rzad 1
;                    }
;
;                    if(rzad_obrabiany == 2)
;                    {
;                    ostateczny_wybor_zacisku();
;                    //PORTE.6 = 1;    //przelacz rzad zaciskow - rzad 2 - na razie nie bo nie ma jeszcze oslon
;
;                    if(cykl_sterownik_1 < 5)
;                        cykl_sterownik_1 = sterownik_1_praca(0x008);
;                    if(cykl_sterownik_2 < 5)                                //ster 1 do 0
;                        cykl_sterownik_2 = sterownik_2_praca(0x001);       //ster 2 pod pin pozy rzad 2
;                    }
;
;
;                    if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
;                        {
;
;                          if(rzad_obrabiany == 2)
;                            {
;                            while(PORTE.6 == 0)
;                                przerzucanie_dociskow();
;                            delay_ms(3000);  //czas na przerzucenie
;                            }
;
;                        cykl_sterownik_1 = 0;
;                        cykl_sterownik_2 = 0;
;                        cykl_sterownik_3 = 0;
;                        cykl_sterownik_4 = 0;
;                        cykl_ilosc_zaciskow = 0;
;                        koniec_rzedu_10 = 0;
;
;
;                        if(rzad_obrabiany == 1)
;                             {
;                             while(sprawdz_pin0(PORTMM,0x77) == 1)
;                                {
;                                }
;                             cykl_glowny = 1;
;                             }
;
;                        if(rzad_obrabiany == 2)
;                             {
;                             while(sprawdz_pin1(PORTMM,0x77) == 1)
;                                {
;                                }
;                             cykl_glowny = 1;
;                             }
;                        }
;
;            break;
;
;
;
;            case 1:
;
;
;                     if(cykl_sterownik_2 < 5 & rzad_obrabiany == 1)
;                          {          //ster 1 nic
;                          PORTE.7 = 1;   //zacisnij zaciski
;                          cykl_sterownik_2 = sterownik_2_praca(a[0]);        //ster 2 pod zacisk
;                          }                                                    //ster 4 na pozycje miedzy rzedzami
;
;                     if(cykl_sterownik_2 < 5 & rzad_obrabiany == 2)
;                        {
;                          PORTE.7 = 1;   //zacisnij zaciski
;                          ostateczny_wybor_zacisku();
;                          cykl_sterownik_2 = sterownik_2_praca(a[1]);
;                         }
;                     if(cykl_sterownik_4 < 5 & cykl_sterownik_2 == 5)
;                        cykl_sterownik_4 = sterownik_4_praca(0x01);
;
;                      if(cykl_sterownik_2 == 5 & cykl_sterownik_4 == 5)
;                        {
;                        cykl_sterownik_1 = 0;
;                        cykl_sterownik_2 = 0;
;                        cykl_sterownik_4 = 0;
;                        szczotka_druc_cykl = 0;
;
;
;                        if(rzad_obrabiany == 1)
;                             {
;                             while(sprawdz_pin0(PORTMM,0x77) == 1)
;                                {
;                                }
;                             cykl_glowny = 2;
;                             }
;
;                        if(rzad_obrabiany == 2)
;                             {
;                             while(sprawdz_pin1(PORTMM,0x77) == 1)
;                                {
;                                }
;                             cykl_glowny = 2;
;                             }
;
;                        }
;
;
;            break;
;
;
;            case 2:
;                    if(rzad_obrabiany == 2)
;                        ostateczny_wybor_zacisku();
;
;                    if(cykl_sterownik_4 < 5)
;                          cykl_sterownik_4 = sterownik_4_praca(a[2]);
;                    if(cykl_sterownik_4 == 5)
;                        {
;                        PORTE.2 = 1;  //wlacz szlifierke
;                        PORTB.4 = 1;   //przedmuch osi
;                        cykl_sterownik_4 = 0;
;                        if(rzad_obrabiany == 1)
;                             {
;                             while(sprawdz_pin0(PORTMM,0x77) == 1)
;                                {
;                                }
;                             cykl_glowny = 3;
;                             }
;
;                        if(rzad_obrabiany == 2)
;                             {
;                             while(sprawdz_pin1(PORTMM,0x77) == 1)
;                                {
;                                }
;                             cykl_glowny = 3;
;                             }
;                        }
;
;            break;
;
;
;            case 3:
;
;                     if(rzad_obrabiany == 2)
;                        ostateczny_wybor_zacisku();
;
;                    if(cykl_sterownik_4 < 5)
;                         cykl_sterownik_4 = sterownik_4_praca(a[3]); //INV
;
;                    if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli)
;                        {
;                        szczotka_druc_cykl++;
;                        cykl_sterownik_4 = 0;
;
;                        if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)
;                            {
;                            if(rzad_obrabiany == 1)
;                             {
;                             while(sprawdz_pin0(PORTMM,0x77) == 1)
;                                {
;                                }
;                             cykl_glowny = 4;
;                             }
;
;                            if(rzad_obrabiany == 2)
;                             {
;                             while(sprawdz_pin1(PORTMM,0x77) == 1)
;                                {
;                                }
;                             cykl_glowny = 4;
;                             }
;                            }
;                        else
;                            {
;                            if(rzad_obrabiany == 1)
;                             {
;                             while(sprawdz_pin0(PORTMM,0x77) == 1)
;                                {
;                                }
;                             cykl_glowny = 2;
;                             }
;
;                        if(rzad_obrabiany == 2)
;                             {
;                             while(sprawdz_pin1(PORTMM,0x77) == 1)
;                                {
;                                }
;                             cykl_glowny = 2;
;                             }
;
;                            }
;                        }
;
;
;
;            break;
;
;            case 4:
;
;
;                      if(rzad_obrabiany == 2)
;                            ostateczny_wybor_zacisku();
;
;                     if(cykl_sterownik_4 < 5)
;                        cykl_sterownik_4 = sterownik_4_praca(0x01);
;
;                     if(cykl_sterownik_4 == 5)
;                        {
;                        PORTE.2 = 0;  //wylacz szlifierke
;                        PORTB.4 = 0;  //wylacz przedmuch osi
;                        cykl_sterownik_4 = 0;
;                        if(rzad_obrabiany == 1)
;                             {
;                             while(sprawdz_pin0(PORTMM,0x77) == 1)
;                                {
;                                }
;                             cykl_glowny = 5;
;                             }
;
;                        if(rzad_obrabiany == 2)
;                             {
;                             while(sprawdz_pin1(PORTMM,0x77) == 1)
;                                {
;                                }
;                             cykl_glowny = 5;
;                             }
;                        }
;            break;
;
;            case 5:
;
;
;                    if(cykl_sterownik_1 < 5 & ruch_zlozony == 0 & rzad_obrabiany == 1)
;                        cykl_sterownik_1 = sterownik_1_praca(0x000);
;                    if(cykl_sterownik_1 < 5 & ruch_zlozony == 0 & rzad_obrabiany == 2)
;                        cykl_sterownik_1 = sterownik_1_praca(0x001);
;
;                     if(rzad_obrabiany == 2)
;                        ostateczny_wybor_zacisku();
;
;                    if(cykl_sterownik_1 == 5 & ruch_zlozony == 0)
;                        {
;                        cykl_sterownik_1 = 0;
;                        ruch_zlozony = 1;
;                        }
;
;                    if(cykl_sterownik_1 < 5 & ruch_zlozony == 1 & rzad_obrabiany == 1)
;                        cykl_sterownik_1 = sterownik_1_praca(a[0]);
;                    if(cykl_sterownik_1 < 5 & ruch_zlozony == 1 & rzad_obrabiany == 2)
;                          cykl_sterownik_1 = sterownik_1_praca(a[1]);
;
;
;                    if(cykl_sterownik_1 < 5 & ruch_zlozony == 2)
;                        cykl_sterownik_1 = sterownik_1_praca(0x003);    //ster 1 do pierwszego dolka
;
;                    if(cykl_sterownik_2 < 5 & koniec_rzedu_10 == 0)
;                        cykl_sterownik_2 = sterownik_2_praca(0x003);       //ster 2 pod nastpeny dolek
;
;
;                    if(cykl_sterownik_2 < 5 & koniec_rzedu_10 == 1 & rzad_obrabiany == 1)
;                        cykl_sterownik_2 = sterownik_2_praca(0x008);      //ster 2 do samego tylu
;                     if(cykl_sterownik_2 < 5 & koniec_rzedu_10 == 1 & rzad_obrabiany == 2)
;                        cykl_sterownik_2 = sterownik_2_praca(0x009);      //ster 2 do samego tylu
;
;                    if((cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5 & ruch_zlozony == 1) | (cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5) & ruch_zlozony == 2)
;                        {
;                        cykl_sterownik_1 = 0;
;                        cykl_sterownik_2 = 0;
;                        cykl_sterownik_4 = 0;
;                        cykl_sterownik_3 = 0;
;                        if(rzad_obrabiany == 1)
;                             {
;                             while(sprawdz_pin0(PORTMM,0x77) == 1)
;                                {
;                                }
;                             cykl_glowny = 6;
;                             }
;
;                        if(rzad_obrabiany == 2)
;                             {
;                             while(sprawdz_pin1(PORTMM,0x77) == 1)
;                                {
;                                }
;                             cykl_glowny = 6;
;                             }
;                        }
;
;            break;
;
;
;
;           case 6:
;
;
;
;
;                    if(cykl_sterownik_3 < 5)
;                        cykl_sterownik_3 = sterownik_3_praca(a[4]);  //abs //krazek scierny do gory
;
;                    if(koniec_rzedu_10 == 1)
;                        cykl_sterownik_4 = 5;
;
;                    if(cykl_sterownik_4 < 5)
;                        cykl_sterownik_4 = sterownik_4_praca(a[2]);    //ABS          //druciak do gory
;
;                     if(rzad_obrabiany == 2)
;                        ostateczny_wybor_zacisku();
;
;
;                    if(cykl_sterownik_4 == 5 & cykl_sterownik_3 == 5)
;                        {
;                        if((cykl_ilosc_zaciskow != il_zaciskow_rzad_1 - 1 & rzad_obrabiany == 1) | (cykl_ilosc_zaciskow != il_zaciskow_rzad_2 - 1 & rzad_obrabiany == 2))
;                            PORTE.2 = 1;  //wlacz szlifierke
;                        PORTB.4 = 1;  //przedmuch osi
;                        PORTE.3 = 1;  //szlifierka 2 (krazek scierny)
;                        cykl_sterownik_3 = 0;
;                        cykl_sterownik_4 = 0;
;                        if(cykl_ilosc_zaciskow > 0)
;                                {
;                                sek12 = 0;    //do przedmuchu
;                                PORT_F.bits.b4 = 1;  //przedmuch zaciskow
;                                PORTF = PORT_F.byte;
;                                }
;                        if(rzad_obrabiany == 1)
;                             {
;                             while(sprawdz_pin0(PORTMM,0x77) == 1)
;                                {
;                                }
;                             cykl_glowny = 7;
;                             }
;
;                        if(rzad_obrabiany == 2)
;                             {
;                             while(sprawdz_pin1(PORTMM,0x77) == 1)
;                                {
;                                }
;                             cykl_glowny = 7;
;                             }
;                        }
;
;           break;
;
;
;           case 7:
;                                                                                              //mini ruch do przygotowania do okregu
;                    if(cykl_sterownik_1 < 5)
;                          cykl_sterownik_1 = sterownik_1_praca(a[5]);
;
;                     if(rzad_obrabiany == 2)
;                        ostateczny_wybor_zacisku();
;
;                    if(cykl_sterownik_1 == 5)
;                        {
;                        cykl_sterownik_1 = 0;
;
;                        szczotka_druc_cykl = 0;
;                        krazek_scierny_cykl_po_okregu = 0;
;                        wykonalem_komplet_okregow = 0;
;                        abs_ster3 = 0;
;                        abs_ster4 = 0;
;                        if(rzad_obrabiany == 1)
;                             {
;                             while(sprawdz_pin0(PORTMM,0x77) == 1)
;                                {
;                                }
;                             cykl_glowny = 8;
;                             }
;
;                        if(rzad_obrabiany == 2)
;                             {
;                             while(sprawdz_pin1(PORTMM,0x77) == 1)
;                                {
;                                }
;                             cykl_glowny = 8;
;                             }
;                        }
;
;
;
;           break;
;
;
;            case 8:
;
;                    if(sek12 > czas_przedmuchu)
;                        {
;                        PORT_F.bits.b4 = 0;  //przedmuch zaciskow
;                        PORTF = PORT_F.byte;
;                        }
;
;
;                     if(rzad_obrabiany == 2)
;                        ostateczny_wybor_zacisku();
;
;                    if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 0)
;                          cykl_sterownik_1 = sterownik_1_praca(a[6]);
;
;                    if(cykl_sterownik_1 == 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 0)
;                        {
;                        cykl_sterownik_1 = 0;
;                        krazek_scierny_cykl_po_okregu++;
;                        }
;
;                    if(krazek_scierny_cykl_po_okregu == krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 0)
;                        {
;                        cykl_sterownik_1 = 0;
;                        wykonalem_komplet_okregow = 1;
;                        }
;
;                    if(koniec_rzedu_10 == 1)
;                        cykl_sterownik_4 = 5;
;
;                    if(cykl_sterownik_4 < 5 & abs_ster4 == 0)
;                         cykl_sterownik_4 = sterownik_4_praca(a[3]); //INV               //szczotka druc
;
;                    if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli)
;                        {
;                        if(koniec_rzedu_10 == 0)
;                            cykl_sterownik_4 = 0;
;                        if(abs_ster4 == 0)
;                            {
;                            szczotka_druc_cykl++;
;                            abs_ster4 = 1;
;                            }
;                        else
;                            abs_ster4 = 0;
;                        }
;
;                    if(cykl_sterownik_3 < 5 & abs_ster3 == 0)
;                         cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV
;
;
;                    if(cykl_sterownik_3 == 5 & krazek_scierny_cykl < krazek_scierny_ilosc_cykli)
;                        {
;
;                         cykl_sterownik_3 = 0;
;                        if(abs_ster3 == 0)
;                            {
;                            krazek_scierny_cykl++;
;                            abs_ster3 = 1;
;                            }
;                        else
;                            abs_ster3 = 0;
;                        }
;
;                    if(cykl_sterownik_3 < 5 & abs_ster3 == 1)
;                        cykl_sterownik_3 = sterownik_3_praca(a[4]);  //ABS          //krazek scierny do gory
;
;                    if(cykl_sterownik_4 < 5 & abs_ster4 == 1)
;                        cykl_sterownik_4 = sterownik_4_praca(a[2]);  //ABS          //druciak do gory
;
;                                                                                           //mini ruch powrotny do okregu, zeby nie szorowal
;                    if(cykl_sterownik_1 < 5 & wykonalem_komplet_okregow == 1)
;                         cykl_sterownik_1 = sterownik_1_praca(a[8]);
;
;
;                    if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 1 &
;                       szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
;                       krazek_scierny_cykl == krazek_scierny_ilosc_cykli &
;                       cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
;                        {
;                        cykl_sterownik_1 = 0;
;                        cykl_sterownik_2 = 0;
;                        cykl_sterownik_3 = 0;
;                        cykl_sterownik_4 = 0;
;                        szczotka_druc_cykl = 0;
;                        krazek_scierny_cykl = 0;
;                        krazek_scierny_cykl_po_okregu = 0;
;                        PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz
;                        PORTF = PORT_F.byte;
;
;
;                        if(rzad_obrabiany == 1)
;                             {
;                             while(sprawdz_pin0(PORTMM,0x77) == 1)
;                                {
;                                }
;                             cykl_glowny = 9;
;                             }
;
;                        if(rzad_obrabiany == 2)
;                             {
;                             while(sprawdz_pin1(PORTMM,0x77) == 1)
;                                {
;                                }
;                             cykl_glowny = 9;
;                             }
;
;
;                        }
;
;                                                                                                //ster 1 - ruch po okregu
;                                                                                                //ster 2 - nic
;                                                                                                //ster 3 - krazek - gora dol
;                                                                                                //ster 4 - druciak - gora dol
;
;            break;
;
;
;            case 9:                                          //cykl 3 == 5
;
;
;                         if(rzad_obrabiany == 1)
;                         {
;                         if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow != il_zaciskow_rzad_1 - 1)
;                              cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
;
;
;                          if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow < il_zaciskow_rzad_1 - 2)
;                            cykl_sterownik_4 = sterownik_4_praca(0x01);  //do pozycji bazowej
;
;
;                         if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow == il_zaciskow_rzad_1 - 1)       //2 marca 2019 wykomentowuje
;                            cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
;
;
;                         if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow >= il_zaciskow_rzad_1 - 2)
;                            cykl_sterownik_4 = sterownik_4_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
;
;                          }
;
;
;                         if(rzad_obrabiany == 2)
;                         {
;                         if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow != il_zaciskow_rzad_2 - 1)
;                            cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
;
;                          if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow < il_zaciskow_rzad_2 - 2)
;                            cykl_sterownik_4 = sterownik_4_praca(0x01);  //do pozycji bazowej
;
;                         if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow == il_zaciskow_rzad_2 - 1)
;                            cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
;
;
;                          if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow >= il_zaciskow_rzad_2 - 2)
;                            cykl_sterownik_4 = sterownik_4_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
;
;                           if(rzad_obrabiany == 2)
;                            ostateczny_wybor_zacisku();
;
;                          }
;
;
;                          if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
;                            {
;                            PORTE.2 = 0;  //wylacz szlifierke
;                            PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
;                            PORTB.4 = 0;  //wylacz przedmuchy
;                            cykl_sterownik_4 = 0;
;                            cykl_sterownik_3 = 0;
;                            cykl_ilosc_zaciskow++;
;                            ruch_zlozony = 2;                       //il_zaciskow_rzad_1
;
;
;                            if(rzad_obrabiany == 1)
;                             {
;                             while(sprawdz_pin0(PORTMM,0x77) == 1)
;                                {
;                                }
;                             cykl_glowny = 10;
;                             }
;
;                        if(rzad_obrabiany == 2)
;                             {
;                             while(sprawdz_pin1(PORTMM,0x77) == 1)
;                                {
;                                }
;                             cykl_glowny = 10;
;                             }
;
;
;                            }
;
;
;            break;
;*/
;
;
;
;
;
;/*
;case 10:
;
;                                               //wywali ten warunek jak zadziala
;                     if(rzad_obrabiany == 1 & cykl_glowny != 0)
;                            {
;                            wartosc_parametru_panelu(cykl_ilosc_zaciskow,0,16);  //wykonano zaciskow rzad1
;                            if(cykl_ilosc_zaciskow <  il_zaciskow_rzad_1 - 1)
;                                {
;                                cykl_glowny = 5;
;                                koniec_rzedu_10 = 0;
;                                }
;
;                            if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 - 1)
;                                {
;                                cykl_glowny = 5;
;                                koniec_rzedu_10 = 1;
;                                }
;
;                            if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 & il_zaciskow_rzad_1 == 10)
;                                {
;                                cykl_glowny = 11;
;                                }
;
;                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 & il_zaciskow_rzad_1 != 10)  /////zmieniam + 1 20.02
;                                {
;                                cykl_glowny = 14;
;                                }
;                            }
;
;
;                             if(rzad_obrabiany == 2)
;                                ostateczny_wybor_zacisku();
;
;                            if(rzad_obrabiany == 2 & cykl_glowny != 0)
;                            {
;                            wartosc_parametru_panelu(cykl_ilosc_zaciskow,0,96);  //wykonano zaciskow rzad1
;                            if(cykl_ilosc_zaciskow <  il_zaciskow_rzad_2 - 1)
;                                {
;                                cykl_glowny = 5;
;                                koniec_rzedu_10 = 0;
;                                }
;
;                            if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 - 1)
;                                {
;                                cykl_glowny = 5;
;                                koniec_rzedu_10 = 1;
;                                }
;
;                            if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 & il_zaciskow_rzad_2 == 10)
;                                {
;                                cykl_glowny = 12;
;                                }
;
;
;                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 & il_zaciskow_rzad_2 != 10)   ///////////////////zmieniam + 1 20.02
;                                {
;                                cykl_glowny = 14;
;                                }
;                            }
;
;
;
;            break;
;
;
;
;            case 11:
;
;                              if(rzad_obrabiany == 2)
;                                ostateczny_wybor_zacisku();
;
;                             //ster 1 ucieka od szafy
;                             if(cykl_sterownik_1 < 5)
;                                    cykl_sterownik_1 = sterownik_1_praca(0x007);     //uciekamy do tylu
;
;                             if(cykl_sterownik_2 < 5)
;                                    cykl_sterownik_2 = sterownik_2_praca(0x190);     //pod dolek ostatni 10 do przedmuchu rzad 1
;
;                             if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
;                                    {
;                                    PORT_F.bits.b4 = 1;  //przedmuch zaciskow
;                                    PORTF = PORT_F.byte;
;                                    cykl_sterownik_1 = 0;
;                                    cykl_sterownik_2 = 0;
;
;                                    if(rzad_obrabiany == 1)
;                                    {
;                                        while(sprawdz_pin0(PORTMM,0x77) == 1)
;                                            {
;                                            }
;                                    cykl_glowny = 13;
;                                    }
;
;                                    if(rzad_obrabiany == 2)
;                                    {
;                                    while(sprawdz_pin1(PORTMM,0x77) == 1)
;                                        {
;                                        }
;                                        cykl_glowny = 13;
;                                    }
;
;
;
;
;                                    }
;            break;
;
;
;            case 12:
;
;                             if(rzad_obrabiany == 2)
;                                ostateczny_wybor_zacisku();
;
;                               //ster 1 ucieka od szafy
;                             if(cykl_sterownik_1 < 5)
;                                    cykl_sterownik_1 = sterownik_1_praca(0x007);     //uciekamy do tylu
;
;                            if(cykl_sterownik_2 < 5)
;                                    cykl_sterownik_2 = sterownik_2_praca(0x191);     //pod dolek ostatni 10 do przedmuchu rzad 2
;
;                             if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
;                                    {
;                                    PORT_F.bits.b4 = 1;  //przedmuch zaciskow
;                                    PORTF = PORT_F.byte;
;                                    cykl_sterownik_1 = 0;
;                                    cykl_sterownik_2 = 0;
;
;                                    if(rzad_obrabiany == 1)
;                                    {
;                                        while(sprawdz_pin0(PORTMM,0x77) == 1)
;                                            {
;                                            }
;                                    cykl_glowny = 13;
;                                    }
;
;                                    if(rzad_obrabiany == 2)
;                                    {
;                                    while(sprawdz_pin1(PORTMM,0x77) == 1)
;                                        {
;                                        }
;                                        cykl_glowny = 13;
;                                    }
;
;
;
;                                    }
;
;
;            break;
;
;
;
;            case 13:
;
;
;                              if(rzad_obrabiany == 2)
;                                ostateczny_wybor_zacisku();
;
;                             if(cykl_sterownik_2 < 5)
;                                    cykl_sterownik_2 = sterownik_2_praca(0x192);     //okrag
;                             if(cykl_sterownik_2 == 5)
;                                    {
;                                    PORT_F.bits.b4 = 0;  //przedmuch zaciskow - wylaczenie
;                                    PORTF = PORT_F.byte;
;                                    cykl_sterownik_2 = 0;
;
;
;                                    if(rzad_obrabiany == 1)
;                                    {
;                                        while(sprawdz_pin0(PORTMM,0x77) == 1)
;                                            {
;                                            }
;                                    cykl_glowny = 16;
;                                    }
;
;                                    if(rzad_obrabiany == 2)
;                                    {
;                                    while(sprawdz_pin1(PORTMM,0x77) == 1)
;                                        {
;                                        }
;                                        cykl_glowny = 16;
;                                    }
;
;
;
;                                    }
;
;            break;
;
;
;
;            case 14:
;
;
;                     if(rzad_obrabiany == 2)
;                        ostateczny_wybor_zacisku();
;
;                    if(cykl_sterownik_1 < 5)
;                        cykl_sterownik_1 = sterownik_1_praca(0x003);     //pod nastepny dolek zeby przedmuchac
;                    if(cykl_sterownik_1 == 5)
;                        {
;                        cykl_sterownik_1 = 0;
;                        sek12 = 0;
;
;                        if(rzad_obrabiany == 1)
;                                    {
;                                        while(sprawdz_pin0(PORTMM,0x77) == 1)
;                                            {
;                                            }
;                                    cykl_glowny = 15;
;                                    }
;
;                                    if(rzad_obrabiany == 2)
;                                    {
;                                    while(sprawdz_pin1(PORTMM,0x77) == 1)
;                                        {
;                                        }
;                                        cykl_glowny = 15;
;                                    }
;
;
;
;
;
;                        }
;
;            break;
;
;
;
;            case 15:
;
;                     if(rzad_obrabiany == 2)
;                        ostateczny_wybor_zacisku();
;
;                    //przedmuch
;                    PORT_F.bits.b4 = 1;  //przedmuch zaciskow
;                    PORTF = PORT_F.byte;
;                    if(sek12 > czas_przedmuchu)
;                        {
;                        PORT_F.bits.b4 = 0;  //przedmuch zaciskow
;                        PORTF = PORT_F.byte;
;
;                        if(rzad_obrabiany == 1)
;                                    {
;                                        while(sprawdz_pin0(PORTMM,0x77) == 1)
;                                            {
;                                            }
;                                    cykl_glowny = 16;
;                                    }
;
;                                    if(rzad_obrabiany == 2)
;                                    {
;                                    while(sprawdz_pin1(PORTMM,0x77) == 1)
;                                        {
;                                        }
;                                        cykl_glowny = 16;
;                                    }
;
;
;
;
;                        }
;            break;
;
;
;            case 16:
;
;                     if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 & wykonalem_rzedow == 0)  /////zmieniam + 1 20.02
;                                {
;                                cykl_ilosc_zaciskow = 0;
;                                PORTE.7 = 0;   //pusc zaciski
;                                if(il_zaciskow_rzad_2 > 0)
;                                    {
;
;                                    rzad_obrabiany = 2;
;                                    wybor_linijek_sterownikow(2);  //rzad 2
;                                    cykl_glowny = 0;
;                                    }
;                                else
;                                    cykl_glowny = 17;
;
;                                wykonalem_rzedow = 1;
;                                }
;
;                       if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 & il_zaciskow_rzad_2 > 0 & wykonalem_rzedow == 1)   ///////////////////zmieniam + 1 20.02
;                                {
;                                PORTE.7 = 0;   //pusc zaciski
;                                cykl_ilosc_zaciskow = 0;
;                                cykl_glowny = 17;
;                                rzad_obrabiany = 1;
;                                wykonalem_rzedow = 2;
;                                }
;
;
;
;
;                        if(il_zaciskow_rzad_1 > 0 & il_zaciskow_rzad_2 > 0 & wykonalem_rzedow == 2)
;                                  {
;                                  rzad_obrabiany = 1;
;                                  wykonalem_rzedow = 0;
;                                  PORTE.7 = 0;   //pusc zaciski
;                                  //PORTE.6 = 0;    //przelacz rzad zaciskow - rzad 1 - tego na razie nie poki nie ma oslon
;                                  PORTB.6 = 0;   ////zielona lampka
;                                  wartosc_parametru_panelu(0,0,64);
;                                  }
;
;                            if(il_zaciskow_rzad_1 > 0 & il_zaciskow_rzad_2 == 0 & wykonalem_rzedow == 1)
;                                  {
;                                  rzad_obrabiany = 1;
;                                  wykonalem_rzedow = 0;
;                                  PORTE.6 = 1;    //przelacz rzad zaciskow - rzad 2
;                                  PORTB.6 = 0;   ////zielona lampka
;                                  wartosc_parametru_panelu(0,0,64);
;                                  }
;
;
;
;            break;
;
;
;            case 17:
;
;
;                                 if(cykl_sterownik_1 < 5)
;                                    cykl_sterownik_1 = sterownik_1_praca(0x009);
;                                 if(cykl_sterownik_2 < 5)                                //ster 1 do 0
;                                    cykl_sterownik_2 = sterownik_2_praca(0x000);       //ster 2 pod pin pozy rzad 1
;
;                                    if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
;                                        {
;                                        cykl_sterownik_1 = 0;
;                                        cykl_sterownik_2 = 0;
;                                        cykl_sterownik_3 = 0;
;                                        cykl_sterownik_4 = 0;
;                                        jestem_w_trakcie_czyszczenia_calosci = 0;
;                                        start = 0;
;                                        cykl_glowny = 0;
;                                        }
;
;
;
;
;            break;
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
	CALL SUBOPT_0xFA
	ADIW R28,3
	RET
__print_G103:
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL SUBOPT_0x3A
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
	CALL SUBOPT_0x115
_0x206001E:
	RJMP _0x206001B
_0x206001C:
	CPI  R30,LOW(0x1)
	BRNE _0x206001F
	CPI  R18,37
	BRNE _0x2060020
	CALL SUBOPT_0x115
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
	CALL SUBOPT_0x116
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x117
	RJMP _0x2060030
_0x206002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2060032
	CALL SUBOPT_0x116
	CALL SUBOPT_0x118
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2060033
_0x2060032:
	CPI  R30,LOW(0x70)
	BRNE _0x2060035
	CALL SUBOPT_0x116
	CALL SUBOPT_0x118
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
	CALL SUBOPT_0x116
	CALL SUBOPT_0x119
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
	CALL SUBOPT_0x116
	CALL SUBOPT_0x119
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
	CALL SUBOPT_0x115
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
	CALL SUBOPT_0x115
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
	CALL SUBOPT_0x117
	CPI  R21,0
	BREQ _0x206006B
	SUBI R21,LOW(1)
_0x206006B:
_0x206006A:
_0x2060069:
_0x2060061:
	CALL SUBOPT_0x115
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
	CALL SUBOPT_0x117
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
	CALL SUBOPT_0x37
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(90)
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(165)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x5:
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x7:
	CALL __CWD2
	__CPD2N 0x359D0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(0)
	STS  _czas_pracy_szczotki_drucianej,R30
	STS  _czas_pracy_szczotki_drucianej+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(_czas_pracy_szczotki_drucianej_h)
	LDI  R27,HIGH(_czas_pracy_szczotki_drucianej_h)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(0)
	STS  _czas_pracy_krazka_sciernego,R30
	STS  _czas_pracy_krazka_sciernego+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB:
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	CALL _putchar
	LDI  R30,LOW(130)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:133 WORDS
SUBOPT_0xE:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x10:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x12:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EQW12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 154 TIMES, CODE SIZE REDUCTION:609 WORDS
SUBOPT_0x13:
	LDI  R26,LOW(_macierz_zaciskow)
	LDI  R27,HIGH(_macierz_zaciskow)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x14:
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
SUBOPT_0x15:
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 37 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x16:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _komunikat_na_panel

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x17:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x18:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x19:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1A:
	MOVW R26,R30
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	CALL __GEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_stala)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_stala)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	LDI  R26,LOW(_czas_pracy_szczotki_drucianej_stala)
	LDI  R27,HIGH(_czas_pracy_szczotki_drucianej_stala)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1D:
	LDI  R26,LOW(_szczotka_druciana_ilosc_cykli)
	LDI  R27,HIGH(_szczotka_druciana_ilosc_cykli)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1E:
	LDI  R26,LOW(_krazek_scierny_ilosc_cykli)
	LDI  R27,HIGH(_krazek_scierny_ilosc_cykli)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1F:
	LDI  R26,LOW(_krazek_scierny_cykl_po_okregu_ilosc)
	LDI  R27,HIGH(_krazek_scierny_cykl_po_okregu_ilosc)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	LDI  R26,LOW(_czas_pracy_szczotki_drucianej_h)
	LDI  R27,HIGH(_czas_pracy_szczotki_drucianej_h)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	LDI  R26,LOW(_czas_pracy_krazka_sciernego_h)
	LDI  R27,HIGH(_czas_pracy_krazka_sciernego_h)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 45 TIMES, CODE SIZE REDUCTION:261 WORDS
SUBOPT_0x23:
	LDI  R30,LOW(_PORTMM)
	LDI  R31,HIGH(_PORTMM)
	LDI  R26,1
	CALL __PUTPARL
	LDI  R30,LOW(119)
	LDI  R31,HIGH(119)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 100 TIMES, CODE SIZE REDUCTION:195 WORDS
SUBOPT_0x24:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x25:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _odczytaj_parametr

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x26:
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _odczytaj_parametr

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	STS  _il_zaciskow_rzad_1,R30
	STS  _il_zaciskow_rzad_1+1,R31
	RJMP SUBOPT_0x24

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x28:
	CALL _odczytaj_parametr
	STS  _il_zaciskow_rzad_2,R30
	STS  _il_zaciskow_rzad_2+1,R31
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x29:
	LDI  R26,LOW(_szczotka_druciana_ilosc_cykli)
	LDI  R27,HIGH(_szczotka_druciana_ilosc_cykli)
	CALL __EEPROMWRW
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2A:
	CALL _odczytaj_parametr
	LDI  R26,LOW(_krazek_scierny_ilosc_cykli)
	LDI  R27,HIGH(_krazek_scierny_ilosc_cykli)
	CALL __EEPROMWRW
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	CALL _odczytaj_parametr
	LDI  R26,LOW(_krazek_scierny_cykl_po_okregu_ilosc)
	LDI  R27,HIGH(_krazek_scierny_cykl_po_okregu_ilosc)
	CALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2C:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2D:
	LDI  R30,LOW(112)
	LDI  R31,HIGH(112)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2E:
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2F:
	LDI  R30,LOW(96)
	LDI  R31,HIGH(96)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x30:
	LDI  R30,LOW(_PORTJJ)
	LDI  R31,HIGH(_PORTJJ)
	LDI  R26,1
	CALL __PUTPARL
	LDI  R30,LOW(121)
	LDI  R31,HIGH(121)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:137 WORDS
SUBOPT_0x31:
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr1
	LDS  R31,_adr1+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr2
	LDS  R31,_adr2+1
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:107 WORDS
SUBOPT_0x32:
	LDS  R30,_adr1
	LDS  R31,_adr1+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr2
	LDS  R31,_adr2+1
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:87 WORDS
SUBOPT_0x33:
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
SUBOPT_0x34:
	OR   R30,R0
	STS  _PORT_CZYTNIK,R30
	RJMP SUBOPT_0x33

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x35:
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x36:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 145 TIMES, CODE SIZE REDUCTION:285 WORDS
SUBOPT_0x37:
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 69 TIMES, CODE SIZE REDUCTION:269 WORDS
SUBOPT_0x38:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _komunikat_z_czytnika_kodow

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x39:
	ST   X+,R30
	ST   X,R31
	MOVW R30,R16
	RJMP SUBOPT_0x13

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x3A:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x3B:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x32

;OPTIMIZER ADDED SUBROUTINE, CALLED 136 TIMES, CODE SIZE REDUCTION:537 WORDS
SUBOPT_0x3C:
	STS  _a,R30
	STS  _a+1,R31
	__POINTW1MN _a,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 106 TIMES, CODE SIZE REDUCTION:417 WORDS
SUBOPT_0x3D:
	LDI  R26,LOW(17)
	LDI  R27,HIGH(17)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0x3E:
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
SUBOPT_0x3F:
	LDI  R26,LOW(16)
	LDI  R27,HIGH(16)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x40:
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
SUBOPT_0x41:
	__POINTW1MN _a,18
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x42:
	LDI  R26,LOW(24)
	LDI  R27,HIGH(24)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:269 WORDS
SUBOPT_0x43:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
	STD  Z+0,R26
	STD  Z+1,R27
	RJMP SUBOPT_0x41

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x44:
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0x45:
	STD  Z+0,R26
	STD  Z+1,R27
	RJMP SUBOPT_0x41

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:85 WORDS
SUBOPT_0x46:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(17)
	LDI  R27,HIGH(17)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x47:
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x48:
	LDI  R26,LOW(25)
	LDI  R27,HIGH(25)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x49:
	LDI  R26,LOW(33)
	LDI  R27,HIGH(33)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4A:
	LDI  R26,LOW(32)
	LDI  R27,HIGH(32)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP SUBOPT_0x43

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4B:
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
SUBOPT_0x4C:
	LDI  R26,LOW(29)
	LDI  R27,HIGH(29)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4D:
	LDI  R26,LOW(409)
	LDI  R27,HIGH(409)
	RJMP SUBOPT_0x43

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x4E:
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4F:
	LDI  R26,LOW(24)
	LDI  R27,HIGH(24)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	RJMP SUBOPT_0x46

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x50:
	LDI  R26,LOW(32)
	LDI  R27,HIGH(32)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x51:
	LDI  R26,LOW(33)
	LDI  R27,HIGH(33)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x52:
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP SUBOPT_0x43

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x53:
	LDI  R26,LOW(30)
	LDI  R27,HIGH(30)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RJMP SUBOPT_0x4E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x54:
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
SUBOPT_0x55:
	LDI  R26,LOW(412)
	LDI  R27,HIGH(412)
	RJMP SUBOPT_0x43

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x56:
	__POINTW1MN _a,8
	LDI  R26,LOW(30)
	LDI  R27,HIGH(30)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP SUBOPT_0x46

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:186 WORDS
SUBOPT_0x57:
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
	RJMP SUBOPT_0x45

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x58:
	LDI  R26,LOW(27)
	LDI  R27,HIGH(27)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x59:
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
SUBOPT_0x5A:
	LDI  R26,LOW(25)
	LDI  R27,HIGH(25)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	RJMP SUBOPT_0x46

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x5B:
	LDI  R26,LOW(28)
	LDI  R27,HIGH(28)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5C:
	LDI  R26,LOW(26)
	LDI  R27,HIGH(26)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5D:
	LDI  R26,LOW(22)
	LDI  R27,HIGH(22)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(403)
	LDI  R27,HIGH(403)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x5E:
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	RJMP SUBOPT_0x46

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x5F:
	LDI  R26,LOW(30)
	LDI  R27,HIGH(30)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x60:
	LDI  R26,LOW(25)
	LDI  R27,HIGH(25)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(403)
	LDI  R27,HIGH(403)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x61:
	LDI  R26,LOW(20)
	LDI  R27,HIGH(20)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x62:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x63:
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	LDI  R26,LOW(36)
	LDI  R27,HIGH(36)
	RJMP SUBOPT_0x62

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x64:
	LDI  R26,LOW(406)
	LDI  R27,HIGH(406)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x65:
	LDI  R26,LOW(35)
	LDI  R27,HIGH(35)
	RJMP SUBOPT_0x62

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x66:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x67:
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	RJMP SUBOPT_0x62

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x68:
	LDI  R26,LOW(25)
	LDI  R27,HIGH(25)
	RJMP SUBOPT_0x62

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x69:
	__POINTW1MN _a,8
	RJMP SUBOPT_0x4C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6A:
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	RJMP SUBOPT_0x67

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6B:
	__POINTW1MN _a,8
	LDI  R26,LOW(23)
	LDI  R27,HIGH(23)
	RJMP SUBOPT_0x62

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6C:
	LDI  R26,LOW(403)
	LDI  R27,HIGH(403)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(19)
	LDI  R27,HIGH(19)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6D:
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6E:
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	LDI  R26,LOW(19)
	LDI  R27,HIGH(19)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6F:
	LDI  R26,LOW(24)
	LDI  R27,HIGH(24)
	RJMP SUBOPT_0x62

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x70:
	LDI  R26,LOW(18)
	LDI  R27,HIGH(18)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,8
	RJMP SUBOPT_0x65

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x71:
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	STD  Z+0,R26
	STD  Z+1,R27
	__POINTW1MN _a,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x72:
	LDS  R30,_a
	LDS  R31,_a+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x73:
	__GETW1MN _a,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x74:
	__GETW1MN _a,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x75:
	ADIW R30,1
	__PUTW1MN _a,12
	__GETW1MN _a,12
	ADIW R30,1
	__PUTW1MN _a,16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x76:
	__GETW1MN _a,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x77:
	LDS  R26,_wejscie_krazka_sciernego_w_pow_boczna_cylindra
	LDS  R27,_wejscie_krazka_sciernego_w_pow_boczna_cylindra+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x78:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	MOV  R0,R30
	LDS  R26,_predkosc_ruchow_po_okregu_krazek_scierny
	LDS  R27,_predkosc_ruchow_po_okregu_krazek_scierny+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x79:
	__PUTW1MN _a,10
	RJMP SUBOPT_0x74

;OPTIMIZER ADDED SUBROUTINE, CALLED 41 TIMES, CODE SIZE REDUCTION:77 WORDS
SUBOPT_0x7A:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x7B:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x7C:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _wartosc_parametru_panelu

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7D:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x35

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:53 WORDS
SUBOPT_0x7E:
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr3
	LDS  R31,_adr3+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr4
	LDS  R31,_adr4+1
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x7F:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr3
	LDS  R31,_adr3+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adr4
	LDS  R31,_adr4+1
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x80:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x81:
	CALL _sprawdz_pin0
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x82:
	CALL _sprawdz_pin1
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x83:
	CALL _sprawdz_pin3
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0x84:
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
SUBOPT_0x85:
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
SUBOPT_0x86:
	CALL _sprawdz_pin7
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x87:
	CALL _sprawdz_pin6
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x88:
	CALL _sprawdz_pin5
	LDI  R26,LOW(1)
	CALL __EQB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x89:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8A:
	AND  R30,R26
	MOV  R0,R30
	LDS  R26,_czekaj_az_puszcze
	LDS  R27,_czekaj_az_puszcze+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0x8B:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x8C:
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
SUBOPT_0x8D:
	LDI  R30,LOW(0)
	STS  _czekaj_az_puszcze,R30
	STS  _czekaj_az_puszcze+1,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8E:
	LDI  R30,LOW(0)
	STS  _sek11,R30
	STS  _sek11+1,R30
	STS  _sek11+2,R30
	STS  _sek11+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8F:
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _wartosc_parametru_panelu

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x90:
	LDI  R30,LOW(0)
	STS  _sek1,R30
	STS  _sek1+1,R30
	STS  _sek1+2,R30
	STS  _sek1+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x91:
	__CPD2N 0x2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 26 TIMES, CODE SIZE REDUCTION:47 WORDS
SUBOPT_0x92:
	STS  _cykl_sterownik_1,R30
	STS  _cykl_sterownik_1+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x93:
	LDI  R30,LOW(0)
	STS  _sek3,R30
	STS  _sek3+1,R30
	STS  _sek3+2,R30
	STS  _sek3+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x94:
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x95:
	OR   R30,R0
	STS  _PORT_F,R30
	LDS  R30,_PORT_STER3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x96:
	STS  _PORT_F,R30
	STS  98,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x97:
	LDI  R30,LOW(0)
	STS  _sek2,R30
	STS  _sek2+1,R30
	STS  _sek2+2,R30
	STS  _sek2+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 26 TIMES, CODE SIZE REDUCTION:47 WORDS
SUBOPT_0x98:
	STS  _cykl_sterownik_3,R30
	STS  _cykl_sterownik_3+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x99:
	STS  _PORT_F,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x9A:
	LDI  R30,LOW(0)
	STS  _sek4,R30
	STS  _sek4+1,R30
	STS  _sek4+2,R30
	STS  _sek4+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 25 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x9B:
	STS  _cykl_sterownik_4,R30
	STS  _cykl_sterownik_4+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x9C:
	MOVW R26,R28
	ADIW R26,6
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9D:
	LDS  R26,_test_geometryczny_rzad_1
	LDS  R27,_test_geometryczny_rzad_1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9E:
	LDS  R26,_test_geometryczny_rzad_2
	LDS  R27,_test_geometryczny_rzad_2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x9F:
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
SUBOPT_0xA0:
	LDS  R26,_il_zaciskow_rzad_1
	LDS  R27,_il_zaciskow_rzad_1+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __GTW12
	AND  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xA1:
	__GETW1MN _macierz_zaciskow,2
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	CALL __NEW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:357 WORDS
SUBOPT_0xA2:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xA3:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 39 TIMES, CODE SIZE REDUCTION:73 WORDS
SUBOPT_0xA4:
	LDS  R26,_cykl_sterownik_3
	LDS  R27,_cykl_sterownik_3+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0xA5:
	CALL _sterownik_3_praca
	RJMP SUBOPT_0x98

;OPTIMIZER ADDED SUBROUTINE, CALLED 38 TIMES, CODE SIZE REDUCTION:71 WORDS
SUBOPT_0xA6:
	LDS  R26,_cykl_sterownik_4
	LDS  R27,_cykl_sterownik_4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0xA7:
	CALL _sterownik_4_praca
	RJMP SUBOPT_0x9B

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:93 WORDS
SUBOPT_0xA8:
	RCALL SUBOPT_0xA4
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	MOV  R0,R30
	RCALL SUBOPT_0xA6
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:61 WORDS
SUBOPT_0xA9:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_3,R30
	STS  _cykl_sterownik_3+1,R30
	STS  _cykl_sterownik_4,R30
	STS  _cykl_sterownik_4+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 41 TIMES, CODE SIZE REDUCTION:77 WORDS
SUBOPT_0xAA:
	LDS  R26,_cykl_sterownik_1
	LDS  R27,_cykl_sterownik_1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0xAB:
	CALL _sterownik_1_praca
	RJMP SUBOPT_0x92

;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0xAC:
	LDS  R26,_cykl_sterownik_2
	LDS  R27,_cykl_sterownik_2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xAD:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0xAE:
	CALL _sterownik_2_praca
	RJMP SUBOPT_0x94

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0xAF:
	RCALL SUBOPT_0xAA
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	MOV  R0,R30
	RCALL SUBOPT_0xAC
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB0:
	RCALL SUBOPT_0x72
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xB1:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xA5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB2:
	MOVW R26,R18
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	MOV  R0,R30
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:48 WORDS
SUBOPT_0xB3:
	__GETWRN 16,17,6
	MOVW R30,R18
	RJMP SUBOPT_0x9C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB4:
	MOVW R26,R18
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB5:
	MOVW R26,R18
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB6:
	MOVW R26,R18
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB7:
	MOVW R26,R18
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB8:
	MOVW R26,R18
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB9:
	MOVW R26,R18
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xBA:
	MOVW R26,R18
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xBB:
	MOVW R26,R18
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __EQW12
	MOV  R0,R30
	LDD  R26,Y+24
	LDD  R27,Y+24+1
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xBC:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xAB

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xBD:
	LDS  R26,_il_zaciskow_rzad_2
	LDS  R27,_il_zaciskow_rzad_2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xBE:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __GTW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xBF:
	__GETW1MN _macierz_zaciskow,4
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	CALL __NEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC0:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _wybor_linijek_sterownikow

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC1:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC2:
	__GETW1MN _a,2
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC3:
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC4:
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC5:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC6:
	LDI  R30,LOW(505)
	LDI  R31,HIGH(505)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC7:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xC8:
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xC9:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _rzad_obrabiany,R30
	STS  _rzad_obrabiany+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xCA:
	LDI  R30,LOW(0)
	STS  _wykonalem_rzedow,R30
	STS  _wykonalem_rzedow+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xCB:
	LDI  R30,LOW(0)
	STS  _cykl_ilosc_zaciskow,R30
	STS  _cykl_ilosc_zaciskow+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xCC:
	RCALL SUBOPT_0xBD
	RJMP SUBOPT_0xBE

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xCD:
	LDS  R30,_il_zaciskow_rzad_2
	LDS  R31,_il_zaciskow_rzad_2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 63 TIMES, CODE SIZE REDUCTION:121 WORDS
SUBOPT_0xCE:
	LDS  R26,_rzad_obrabiany
	LDS  R27,_rzad_obrabiany+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xCF:
	LDI  R30,LOW(0)
	STS  _koniec_rzedu_10,R30
	STS  _koniec_rzedu_10+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD0:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xD1:
	RCALL SUBOPT_0xAC
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __LTW12
	MOV  R0,R30
	RJMP SUBOPT_0xCE

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xD2:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0xD3:
	RCALL SUBOPT_0xA6
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xD4:
	MOV  R0,R30
	RCALL SUBOPT_0xAC
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __EQW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD5:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD6:
	RCALL SUBOPT_0xAC
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xD7:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_1,R30
	STS  _cykl_sterownik_1+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xD8:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R30
	STS  _cykl_sterownik_4,R30
	STS  _cykl_sterownik_4+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD9:
	STS  _szczotka_druc_cykl,R30
	STS  _szczotka_druc_cykl+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xDA:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xDB:
	__GETW1MN _a,4
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xA3

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xDC:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_4,R30
	STS  _cykl_sterownik_4+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xDD:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xDE:
	CALL __EQW12
	MOV  R0,R30
	RJMP SUBOPT_0x1D

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xDF:
	LDS  R26,_szczotka_druc_cykl
	LDS  R27,_szczotka_druc_cykl+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE0:
	LDI  R26,LOW(_szczotka_druc_cykl)
	LDI  R27,HIGH(_szczotka_druc_cykl)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE1:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xE2:
	LDI  R30,LOW(0)
	STS  _ruch_zlozony,R30
	STS  _ruch_zlozony+1,R30
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xE3:
	RCALL SUBOPT_0xAA
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_ruch_zlozony
	LDS  R27,_ruch_zlozony+1
	RJMP SUBOPT_0x8B

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE4:
	AND  R0,R30
	RCALL SUBOPT_0xCE
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE5:
	AND  R0,R30
	RCALL SUBOPT_0xCE
	RJMP SUBOPT_0xD2

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0xE6:
	RCALL SUBOPT_0xAA
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xE7:
	MOV  R0,R30
	LDS  R26,_ruch_zlozony
	LDS  R27,_ruch_zlozony+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE8:
	CALL __LTW12
	RJMP SUBOPT_0xE7

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xE9:
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_koniec_rzedu_10
	LDS  R27,_koniec_rzedu_10+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xEA:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xAE

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xEB:
	STS  _cykl_sterownik_3,R30
	STS  _cykl_sterownik_3+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xEC:
	SBI  0x3,3
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xED:
	RCALL SUBOPT_0xA4
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xEE:
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	SBIW R30,1
	LDS  R26,_cykl_ilosc_zaciskow
	LDS  R27,_cykl_ilosc_zaciskow+1
	CALL __NEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xEF:
	RCALL SUBOPT_0xCD
	SBIW R30,1
	LDS  R26,_cykl_ilosc_zaciskow
	LDS  R27,_cykl_ilosc_zaciskow+1
	CALL __NEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0xF0:
	LDS  R26,_cykl_ilosc_zaciskow
	LDS  R27,_cykl_ilosc_zaciskow+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xF1:
	LDI  R30,LOW(0)
	STS  _sek12,R30
	STS  _sek12+1,R30
	STS  _sek12+2,R30
	STS  _sek12+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xF2:
	LDS  R30,_PORT_F
	ORI  R30,0x10
	RJMP SUBOPT_0x96

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF3:
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF4:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xAB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF5:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wykonalem_komplet_okregow,R30
	STS  _wykonalem_komplet_okregow+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF6:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xF7:
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
SUBOPT_0xF8:
	LDS  R30,_PORT_F
	ANDI R30,0xEF
	RJMP SUBOPT_0x96

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xF9:
	LDS  R26,_krazek_scierny_cykl_po_okregu
	LDS  R27,_krazek_scierny_cykl_po_okregu+1
	CALL __LTW12
	AND  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	RJMP SUBOPT_0x8B

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xFA:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xFB:
	CALL __EQW12
	MOV  R0,R30
	LDS  R26,_wykonalem_komplet_okregow
	LDS  R27,_wykonalem_komplet_okregow+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xFC:
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_abs_ster4
	LDS  R27,_abs_ster4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xFD:
	AND  R0,R30
	LDS  R26,_powrot_przedwczesny_druciak
	LDS  R27,_powrot_przedwczesny_druciak+1
	RJMP SUBOPT_0x8B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xFE:
	CALL __LTW12
	MOV  R0,R30
	LDS  R26,_abs_ster3
	LDS  R27,_abs_ster3+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xFF:
	LDS  R26,_krazek_scierny_cykl
	LDS  R27,_krazek_scierny_cykl+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x100:
	LDS  R26,_powrot_przedwczesny_druciak
	LDS  R27,_powrot_przedwczesny_druciak+1
	RJMP SUBOPT_0x7A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x101:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x102:
	CALL __LTW12
	MOV  R0,R30
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x103:
	SBIW R30,2
	RCALL SUBOPT_0xF0
	CALL __LTW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x104:
	SBIW R30,1
	RCALL SUBOPT_0xF0
	CALL __EQW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x105:
	SBIW R30,2
	RCALL SUBOPT_0xF0
	CALL __GEW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x106:
	CALL __LTW12
	MOV  R0,R30
	RJMP SUBOPT_0xCD

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x107:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x108:
	MOV  R0,R30
	LDS  R26,_cykl_glowny
	LDS  R27,_cykl_glowny+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __NEW12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x109:
	LDS  R30,_cykl_ilosc_zaciskow
	LDS  R31,_cykl_ilosc_zaciskow+1
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10A:
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	SBIW R30,1
	RJMP SUBOPT_0xF0

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x10B:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10C:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _koniec_rzedu_10,R30
	STS  _koniec_rzedu_10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x10D:
	LDS  R30,_il_zaciskow_rzad_1
	LDS  R31,_il_zaciskow_rzad_1+1
	RCALL SUBOPT_0xF0
	CALL __EQW12
	MOV  R0,R30
	LDS  R26,_il_zaciskow_rzad_1
	LDS  R27,_il_zaciskow_rzad_1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x10E:
	STS  _cykl_glowny,R30
	STS  _cykl_glowny+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x10F:
	RCALL SUBOPT_0xCD
	RCALL SUBOPT_0xF0
	CALL __EQW12
	MOV  R0,R30
	RJMP SUBOPT_0xBD

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x110:
	LDI  R30,LOW(0)
	STS  _cykl_sterownik_2,R30
	STS  _cykl_sterownik_2+1,R30
	RCALL SUBOPT_0xCE
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x111:
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	RJMP SUBOPT_0x10E

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x112:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	RJMP SUBOPT_0x10E

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x113:
	LDS  R26,_wykonalem_rzedow
	LDS  R27,_wykonalem_rzedow+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x114:
	LDS  R26,_il_zaciskow_rzad_1
	LDS  R27,_il_zaciskow_rzad_1+1
	RJMP SUBOPT_0xBE

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x115:
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
SUBOPT_0x116:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x117:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x118:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x119:
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

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
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
