/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 2019-05-20
Author  : 
Company : 
Comments: 


Chip type               : ATmega128
Program type            : Application
AVR Core Clock frequency: 16.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 1024
*****************************************************/

#include <mega128.h>

// Standard Input/Output functions
#include <stdio.h>

#include <io.h>
#include <delay.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

int guzik;
int guzik0,guzik1,guzik2;
long int sek80;
int czas_kodu_panela;


interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Place your code here
//16,384 ms
sek80++;


}

void wartosc_parametru_panelu(int wartosc, int adres1, int adres2) 
{
putchar(90);  //5A
putchar(165); //A5
putchar(5);//05
putchar(130);  //82    /
putchar(adres1);    //00
putchar(adres2);   //40
putchar(0);    //00
putchar(wartosc);   //np 5
}


/*
void wartosc_parametru_panelu_stala_pamiec(int wartosc, int adres1, int adres2) 
{

//5AA5 0C 80 56 5A 50 00000000 1000 0010 � Zapis (50) z VP 1000 do pami�ci FLASH 00000000

putchar(90);  //5A
putchar(165); //A5
putchar(12);   //0C
putchar(128);  //80    /
putchar(86);    //56
putchar(90);   //5A
putchar(80);    //50
putchar(0);   //00
putchar(0);   //00
putchar(0);   //00
putchar(0);   //00
putchar(16);   //10
putchar(0);   //0
putchar(0);   //0
putchar(16);   //10
}


void odczyt_parametru_panelu_stala_pamiec(int wartosc, int adres1, int adres2) 
{

//5AA5 0C 80 56 5A A0 00000000 1000 0010 � Odczyt (A0) z pami�ci FLASH 00000000 do VP 1000

putchar(90);  //5A
putchar(165); //A5
putchar(12);   //0C
putchar(128);  //80    /
putchar(86);    //56
putchar(90);   //5A
putchar(160);    //A0
putchar(0);   //00
putchar(0);   //00
putchar(0);   //00
putchar(0);   //00
putchar(16);   //10
putchar(16);   //10
putchar(0);   //0
putchar(16);   //10
}

*/
/*
void wartosc_parametru_panelu_stala_pamiec(int skad_adres1, int skad_adres2, int dokad_adres1, int dokad_adres2) 
{

//5AA5 0C 80 56 5A 50 00000000 1000 0010 � Zapis (50) z VP 1000 do pami�ci FLASH 00000000

putchar(90);  //5A
putchar(165); //A5
putchar(12);   //0C
putchar(128);  //80    /
putchar(86);    //56
putchar(90);   //5A
putchar(80);    //50
putchar(0);   //00
putchar(0);   //00
putchar(0);   //00
putchar(0);   //00
putchar(skad_adres1);   //10
putchar(skad_adres2);   //0
putchar(dokad_adres1);   //0
putchar(dokad_adres2);   //10
}

void wartosc_parametru_panelu_stala_pamiec_1(int skad_adres1, int skad_adres2, int dokad_adres1, int dokad_adres2) 
{

//5AA5 0C 80 56 5A 50 00000000 1000 0010 � Zapis (50) z VP 1000 do pami�ci FLASH 00000000

putchar(90);  //5A
putchar(165); //A5
putchar(12);   //0C
putchar(128);  //80    /
putchar(86);    //56
putchar(90);   //5A
putchar(80);    //50
putchar(0);   //00
putchar(0);   //00
putchar(0);   //00
putchar(16);   //00
putchar(skad_adres1);   //10
putchar(skad_adres2);   //0
putchar(dokad_adres1);   //0
putchar(dokad_adres2);   //10
}


void odczyt_parametru_panelu_stala_pamiec(int dokad_adres1, int dokad_adres2,int skad_adres1, int skad_adres2,) 
{

//5AA5 0C 80 56 5A A0 00000000 1010 0010 � Odczyt (A0) z pami�ci FLASH 00000000 do VP 1010

putchar(90);  //5A
putchar(165); //A5
putchar(12);   //0C
putchar(128);  //80    /
putchar(86);    //56
putchar(90);   //5A
putchar(160);    //A0
putchar(0);   //00
putchar(0);   //00
putchar(0);   //00
putchar(0);   //00
putchar(dokad_adres1);   //10
putchar(dokad_adres2);   //10
putchar(skad_adres1);   //0
putchar(skad_adres2);   //10
}

void odczyt_parametru_panelu_stala_pamiec_1(int dokad_adres1, int dokad_adres2,int skad_adres1, int skad_adres2,) 
{

//5AA5 0C 80 56 5A A0 00000000 1010 0010 � Odczyt (A0) z pami�ci FLASH 00000000 do VP 1010

putchar(90);  //5A
putchar(165); //A5
putchar(12);   //0C
putchar(128);  //80    /
putchar(86);    //56
putchar(90);   //5A
putchar(160);    //A0
putchar(0);   //00
putchar(0);   //00
putchar(0);   //00
putchar(16);   //00
putchar(dokad_adres1);   //10
putchar(dokad_adres2);   //10
putchar(skad_adres1);   //0
putchar(skad_adres2);   //10
}

*/


int odczytaj_parametr(int adres1, int adres2)
{
int z;
z = 0;
putchar(90);
putchar(165);
putchar(4);
putchar(131);
putchar(adres1);
putchar(adres2);  
putchar(1);
getchar();
getchar();
getchar();
getchar();
getchar();
getchar();
getchar();
getchar();
z = getchar();





return z;
}



void wartosc_parametru_panelu_stala_pamiec(int adres_nieulotny1,int skad_adres1, int skad_adres2) 
{

//5AA5 0C 80 56 5A 50 00000000 1000 0010 � Zapis (50) z VP 1000 do pami�ci FLASH 00000000

putchar(90);  //5A
putchar(165); //A5
putchar(12);   //0C
putchar(128);  //80    /
putchar(86);    //56
putchar(90);   //5A
putchar(80);    //50
putchar(0);   //00
putchar(0);   //00
putchar(0);   //00
putchar(adres_nieulotny1);   //00
putchar(skad_adres1);   //10
putchar(skad_adres2);   //0
putchar(0);   //0
putchar(16);   //ile danych
}


void obsluga_trybu_administratora()
{
int guzik0,guzik1,guzik2,guzik3,guzik4,guzik5,guzik6,guzik7,guzik8;
int czas_kodu_panela;

czas_kodu_panela = 0;
      
      guzik0 = odczytaj_parametr(80,144);  
      guzik1 = odczytaj_parametr(80,145);
      guzik2 = odczytaj_parametr(80,146);
      guzik3 = odczytaj_parametr(80,147);  
      guzik4 = odczytaj_parametr(80,148);
      guzik5 = odczytaj_parametr(80,149);
      guzik6 = odczytaj_parametr(80,150);  
      guzik7 = odczytaj_parametr(80,151);
      guzik8 = odczytaj_parametr(80,152);
      
      
      
      
      while(guzik0 == 1 | guzik1 == 1 | guzik2 == 1 |
            guzik3 == 1 | guzik4 == 1 | guzik5 == 1 |
            guzik6 == 1 | guzik7 == 1 | guzik8 == 1)
      
      {
      
      if(czas_kodu_panela == 0)
      {
      sek80 = 0;
      czas_kodu_panela = 1;
      }
      
      guzik0 = odczytaj_parametr(80,144);  
      guzik1 = odczytaj_parametr(80,145);
      guzik2 = odczytaj_parametr(80,146);  /////////
      guzik3 = odczytaj_parametr(80,147);  
      guzik4 = odczytaj_parametr(80,148);  /////////
      guzik5 = odczytaj_parametr(80,149);
      guzik6 = odczytaj_parametr(80,150);  ////////
      guzik7 = odczytaj_parametr(80,151);
      guzik8 = odczytaj_parametr(80,152);
      
      
      //kod to 7 5 3 (przekatna)
      
      if((guzik2 + guzik4 + guzik6) == 3 & (guzik2 == 1 & guzik4 == 1 & guzik6 == 1))
                   {
                   
                   putchar(90);  //5A
                   putchar(165); //A5
                   putchar(4);//04  //zmiana obrazu
                   putchar(128);  //80
                   putchar(3);    //03
                   putchar(0);   //2
                   putchar(0);   //0
                   
                   delay_ms(500);
                   putchar(90);  //5A
                   putchar(165); //A5
                   putchar(3);//03  //znak dzwiekowy ze jestem
                   putchar(128);  //80
                   putchar(2);    //02
                   putchar(16);   //10
                   delay_ms(500);
                   putchar(90);  //5A
                   putchar(165); //A5
                   putchar(3);//03  //znak dzwiekowy ze jestem
                   putchar(128);  //80
                   putchar(2);    //02
                   putchar(16);   //10
                   delay_ms(500);
                   putchar(90);  //5A
                   putchar(165); //A5
                   putchar(3);//03  //znak dzwiekowy ze jestem
                   putchar(128);  //80
                   putchar(2);    //02
                   putchar(16);   //10
                   delay_ms(500);
                   putchar(90);  //5A
                   putchar(165); //A5
                   putchar(3);//03  //znak dzwiekowy ze jestem
                   putchar(128);  //80
                   putchar(2);    //02
                   putchar(16);   //10
                   
                   wartosc_parametru_panelu(0, 80, 144);
                   wartosc_parametru_panelu(0, 80, 145);
                   wartosc_parametru_panelu(0, 80, 146);
                   wartosc_parametru_panelu(0, 80, 147);
                   wartosc_parametru_panelu(0, 80, 148);
                   wartosc_parametru_panelu(0, 80, 149);
                   wartosc_parametru_panelu(0, 80, 150);
                   wartosc_parametru_panelu(0, 80, 151);
                   wartosc_parametru_panelu(0, 80, 152);
                   
                   
                   guzik0 = 0;
                   guzik1 = 0;
                   guzik2 = 0;
                   guzik3 = 0;
                   guzik4 = 0;
                   guzik5 = 0;
                   guzik6 = 0;
                   guzik7 = 0;
                   guzik8 = 0;
                   
                   czas_kodu_panela = 0;
                   }
      
      
      if(sek80 > 320)
                   {
                   guzik = 0;
                   delay_ms(500);
                   putchar(90);  //5A
                   putchar(165); //A5
                   putchar(3);//03  //znak dzwiekowy ze jestem
                   putchar(128);  //80
                   putchar(2);    //02
                   putchar(16);   //10
                   delay_ms(500);
                   putchar(90);  //5A
                   putchar(165); //A5
                   putchar(3);//03  //znak dzwiekowy ze jestem
                   putchar(128);  //80
                   putchar(2);    //02
                   putchar(16);   //10
                   
                   wartosc_parametru_panelu(0, 80, 144);
                   wartosc_parametru_panelu(0, 80, 145);
                   wartosc_parametru_panelu(0, 80, 146);
                   wartosc_parametru_panelu(0, 80, 147);
                   wartosc_parametru_panelu(0, 80, 148);
                   wartosc_parametru_panelu(0, 80, 149);
                   wartosc_parametru_panelu(0, 80, 150);
                   wartosc_parametru_panelu(0, 80, 151);
                   wartosc_parametru_panelu(0, 80, 152);
                   
                   
                   guzik0 = 0;
                   guzik1 = 0;
                   guzik2 = 0;
                   guzik3 = 0;
                   guzik4 = 0;
                   guzik5 = 0;
                   guzik6 = 0;
                   guzik7 = 0;
                   guzik8 = 0;
                   
                   czas_kodu_panela = 0;
                   
                     
                   }
      
      
      }
}


void odczyt_parametru_panelu_stala_pamiec(int adres_nieulotny1,int dokad_adres1,int dokad_adres2) 
{

//5AA5 0C 80 56 5A A0 00000000 1010 0010 � Odczyt (A0) z pami�ci FLASH 00000000 do VP 1010

putchar(90);  //5A
putchar(165); //A5
putchar(12);   //0C
putchar(128);  //80    /
putchar(86);    //56
putchar(90);   //5A
putchar(160);    //A0
putchar(0);   //00
putchar(0);   //00
putchar(0);   //00
putchar(adres_nieulotny1);   //00
putchar(dokad_adres1);   //10
putchar(dokad_adres2);   //10
putchar(0);   //0
putchar(16);   //ile danych
}

// Declare your global variables here

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTA=0xFF;
DDRA=0xFF;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x00;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0x00;

// Port E initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTE=0x00;
DDRE=0x00;

// Port F initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTF=0x00;
DDRF=0x00;

// Port G initialization
// Func4=In Func3=In Func2=In Func1=In Func0=In 
// State4=T State3=T State2=T State1=T State0=T 
PORTG=0x00;
DDRG=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 15,625 kHz
// Mode: Normal top=0xFF
// OC0 output: Disconnected
ASSR=0x00;
TCCR0=0x07;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// OC1C output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
OCR1CH=0x00;
OCR1CL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// Timer/Counter 3 initialization
// Clock source: System Clock
// Clock value: Timer3 Stopped
// Mode: Normal top=0xFFFF
// OC3A output: Discon.
// OC3B output: Discon.
// OC3C output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer3 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR3A=0x00;
TCCR3B=0x00;
TCNT3H=0x00;
TCNT3L=0x00;
ICR3H=0x00;
ICR3L=0x00;
OCR3AH=0x00;
OCR3AL=0x00;
OCR3BH=0x00;
OCR3BL=0x00;
OCR3CH=0x00;
OCR3CL=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
// INT3: Off
// INT4: Off
// INT5: Off
// INT6: Off
// INT7: Off
EICRA=0x00;
EICRB=0x00;
EIMSK=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x01;

ETIMSK=0x00;

// USART0 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART0 Receiver: On
// USART0 Transmitter: On
// USART0 Mode: Asynchronous
// USART0 Baud Rate: 115200
//UCSR0A=0x00;
//UCSR0B=0x18;
//UCSR0C=0x06;
//UBRR0H=0x00;
//UBRR0L=0x08;





// USART0 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART0 Receiver: On
// USART0 Transmitter: On
// USART0 Mode: Asynchronous
// USART0 Baud Rate: 9600
UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
UBRR0H=0x00;
UBRR0L=0x67;






// USART1 initialization
// USART1 disabled
UCSR1B=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC disabled
ADCSRA=0x00;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;


// Global enable interrupts
#asm("sei")



delay_ms(2000);
delay_ms(2000);


putchar(90);  //5A
putchar(165); //A5
putchar(3);//03  //znak dzwiekowy ze jestem
putchar(128);  //80
putchar(2);    //02
putchar(16);   //10

delay_ms(2000);

putchar(90);  //5A
putchar(165); //A5
putchar(3);//03  //znak dzwiekowy ze jestem
putchar(128);  //80
putchar(2);    //02
putchar(16);   //10

delay_ms(2000);

// to dziala na bank to ponizej
/*
wartosc_parametru_panelu(9,16,0);

delay_ms(2000);

putchar(90);  //5A
putchar(165); //A5
putchar(3);//03  //znak dzwiekowy ze jestem
putchar(128);  //80
putchar(2);    //02
putchar(16);   //10

delay_ms(2000);

wartosc_parametru_panelu_stala_pamiec(9,16,0);

delay_ms(2000);

putchar(90);  //5A
putchar(165); //A5
putchar(3);//03  //znak dzwiekowy ze jestem
putchar(128);  //80
putchar(2);    //02
putchar(16);   //10

delay_ms(2000);

odczyt_parametru_panelu_stala_pamiec(9,16,0);

delay_ms(2000);
*/

wartosc_parametru_panelu(1,16,0);
wartosc_parametru_panelu(2,16,16);

wartosc_parametru_panelu_stala_pamiec(0,16,0);

delay_ms(200);

wartosc_parametru_panelu_stala_pamiec(16,16,16);

//delay_ms(1000);
//putchar(adres_nieulotny1);   //00
//putchar(skad_adres1);   //10
//putchar(skad_adres2);   //0

delay_ms(200);

odczyt_parametru_panelu_stala_pamiec(0,16,48);

delay_ms(200);

odczyt_parametru_panelu_stala_pamiec(16,16,32);
//putchar(adres_nieulotny1);   //00
//putchar(dokad_adres1);   //10
//putchar(dokad_adres2);   //10
/*

delay_ms(2000);
wartosc_parametru_panelu_stala_pamiec(16,0,0,16);
delay_ms(2000);
wartosc_parametru_panelu_stala_pamiec_1(16,16,0,16);  //to (32)20 to teoria

//putchar(skad_adres1);   //10
//putchar(skad_adres2);   //0
//putchar(dokad_adres1);   //0
//putchar(dokad_adres2);   //10


delay_ms(2000);
odczyt_parametru_panelu_stala_pamiec(16,48,0,16);
delay_ms(2000);
odczyt_parametru_panelu_stala_pamiec_1(16,32,0,16);



//putchar(dokad_adres1);   //10
//putchar(dokad_adres2);   //10
//putchar(skad_adres1);   //0
//putchar(skad_adres2);   //10

*/
//wartosc_parametru_panelu_stala_pamiec(16,0,0,16);
//putchar(skad_adres1);   //10
//putchar(skad_adres2);   //0
//putchar(dokad_adres1);   //0
//putchar(dokad_adres2);   //10



obsluga_trybu_administratora();



while (1)
      {
      wartosc_parametru_panelu(7, 16, 0);
      //wartosc_parametru_panelu(0, 144, 1);
      //wartosc_parametru_panelu(0, 144, 2);
      
      guzik0 = odczytaj_parametr(144,0);  
      guzik1 = odczytaj_parametr(144,1);
      guzik2 = odczytaj_parametr(144,2);
      
      while(guzik0 == 1 | guzik1 == 1 | guzik2 == 1)
      {
      
      if(czas_kodu_panela == 0)
      {
      sek80 = 0;
      czas_kodu_panela = 1;
      }
      
      guzik0 = odczytaj_parametr(144,0);
      guzik1 = odczytaj_parametr(144,1);
      guzik2 = odczytaj_parametr(144,2);
      
      if((guzik0 + guzik1 + guzik2) == 2 & (guzik0 == 1 & guzik1 == 0 & guzik2 == 1))
                   {
                   guzik = 1;
                 
                   putchar(90);  //5A
                   putchar(165); //A5
                   putchar(4);//04  //zmiana obrazu
                   putchar(128);  //80
                   putchar(3);    //03
                   putchar(0);   //2
                   putchar(2);   //2
                   
                   wartosc_parametru_panelu(guzik+3, 16, 0); 
                   
                   delay_ms(500);
                   putchar(90);  //5A
                   putchar(165); //A5
                   putchar(3);//03  //znak dzwiekowy ze jestem
                   putchar(128);  //80
                   putchar(2);    //02
                   putchar(16);   //10
                   delay_ms(500);
                   putchar(90);  //5A
                   putchar(165); //A5
                   putchar(3);//03  //znak dzwiekowy ze jestem
                   putchar(128);  //80
                   putchar(2);    //02
                   putchar(16);   //10
                   delay_ms(500);
                   putchar(90);  //5A
                   putchar(165); //A5
                   putchar(3);//03  //znak dzwiekowy ze jestem
                   putchar(128);  //80
                   putchar(2);    //02
                   putchar(16);   //10
                   delay_ms(500);
                   putchar(90);  //5A
                   putchar(165); //A5
                   putchar(3);//03  //znak dzwiekowy ze jestem
                   putchar(128);  //80
                   putchar(2);    //02
                   putchar(16);   //10
                   
                   
                   
                   
                   
                   wartosc_parametru_panelu(0, 144, 0);
                   wartosc_parametru_panelu(0, 144, 1);
                   wartosc_parametru_panelu(0, 144, 2);
                   
                     guzik0 = 0;
                     guzik1 = 0;
                     guzik2 = 0;
                   
                   czas_kodu_panela = 0;
                   }
      
      
      if(sek80 > 320)
                   {
                   guzik = 0;
                   delay_ms(500);
                   putchar(90);  //5A
                   putchar(165); //A5
                   putchar(3);//03  //znak dzwiekowy ze jestem
                   putchar(128);  //80
                   putchar(2);    //02
                   putchar(16);   //10
                   delay_ms(500);
                   putchar(90);  //5A
                   putchar(165); //A5
                   putchar(3);//03  //znak dzwiekowy ze jestem
                   putchar(128);  //80
                   putchar(2);    //02
                   putchar(16);   //10
                   
                   
                   wartosc_parametru_panelu(0, 144, 0);
                   wartosc_parametru_panelu(0, 144, 1);
                   wartosc_parametru_panelu(0, 144, 2);
                   
                     guzik0 = 0;
                     guzik1 = 0;
                     guzik2 = 0;
                   
                    czas_kodu_panela = 0;
                   }
      
      
      }
      


      if(guzik == 1)
      {
       guzik = 0;
     
      
      
      PORTA.0 = 0;
      delay_ms(1000);
      PORTA.0 = 1;
      delay_ms(3000);
      delay_ms(3000);
      delay_ms(3000);
      delay_ms(3000);
      delay_ms(3000);
      
      
      }
      // Place your code here

      }
}
