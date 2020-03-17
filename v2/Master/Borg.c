/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 2018-08-31
Author  : 
Company : 
Comments: 


Chip type               : ATmega128
Program type            : Application
AVR Core Clock frequency: 16,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 1024
*****************************************************/

#include <io.h>

#define DATA_REGISTER_EMPTY (1<<UDRE0)
#define RX_COMPLETE (1<<RXC0)
#define FRAMING_ERROR (1<<FE0)
#define PARITY_ERROR (1<<UPE0)
#define DATA_OVERRUN (1<<DOR0)

// Get a character from the USART1 Receiver
#pragma used+
char getchar1(void)
{
unsigned char status;
char data;
while (1)
      {
      while (((status=UCSR1A) & RX_COMPLETE)==0);
      data=UDR1;
      if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
         return data;
      }
}
#pragma used-

// Write a character to the USART1 Transmitter
#pragma used+
void putchar1(char c)
{
while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
UDR1=c;
}
#pragma used-



#include <mega128.h>
#include <delay.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <stdio.h>

// I2C Bus functions
#asm
   .equ __i2c_port=0x12 ;PORTD
   .equ __sda_bit=1
   .equ __scl_bit=0
#endasm
#include <i2c.h>


typedef union{
   struct{
      unsigned char b0:1;
      unsigned char b1:1;
      unsigned char b2:1;
      unsigned char b3:1;
      unsigned char b4:1;
      unsigned char b5:1;
      unsigned char b6:1;
      unsigned char b7:1;      
   }bits;
   unsigned char byte;
}BB;


typedef union{
   struct{
      unsigned char b0:1;
      unsigned char b1:1;
      unsigned char b2:1;
      unsigned char b3:1;
      unsigned char b4:1;
      unsigned char b5:1;      
   }bits;
   unsigned char byte;
}CC;

typedef union{
   struct{
      unsigned char b0:1;
      unsigned char b1:1;
      unsigned char b2:1;
      unsigned char b3:1;
      unsigned char b4:1;
      unsigned char b5:1;
      unsigned char b6:1;
      unsigned char b7:1;
      unsigned char b8:1;      
   }bits;
   unsigned char byte;
}DD;





BB PORT_F;
BB PORTHH,PORT_CZYTNIK;
BB PORTJJ,PORTKK,PORTLL,PORTMM;
CC PORT_STER3,PORT_STER4;
int xxx;

int nr_zacisku,odczytalem_zacisk,il_prob_odczytu;
int macierz_zaciskow[3];
long int sek1,sek2,sek3,sek4,sek5,sek6,sek7,sek8,sek9,sek10,sek11,sek12;
int rzad;
int start;
int cykl;
int aaa,bbb,ccc,ddd;
int pozycjonowanie_LEFS32_300_1;
int pozycjonowanie_LEFS32_300_2;
int il_zaciskow_rzad_1,il_zaciskow_rzad_2;
int cykl_sterownik_1,cykl_sterownik_3,cykl_sterownik_2,cykl_sterownik_4;
int adr1,adr2,adr3,adr4;
int cykl_sterownik_3_wykonalem;
int szczotka_druciana_ilosc_cykli;
int szczotka_druc_cykl;
int cykl_glowny;
int start_kontynuacja;
int ruch_zlozony;
int krazek_scierny_cykl_po_okregu;
int krazek_scierny_cykl_po_okregu_ilosc;
int krazek_scierny_cykl;
int krazek_scierny_ilosc_cykli;
int cykl_ilosc_zaciskow;
int wykonalem_komplet_okregow;
int abs_ster3,abs_ster4;
int koniec_rzedu_10;
int rzad_obrabiany;
int jestem_w_trakcie_czyszczenia_calosci;
int wykonalem_rzedow;
bit guzik1_przelaczania_zaciskow,guzik2_przelaczania_zaciskow;
bit zmienna_przelaczanie_zaciskow;
int czekaj_az_puszcze, czek1, czek2;
int czas_przedmuchu;
int a[10];

char sprawdz_pin0(BB PORT, int numer_pcf)
{
i2c_start();
i2c_write(numer_pcf);
PORT.byte = i2c_read(0);
i2c_stop();


return PORT.bits.b0; 
}

char sprawdz_pin1(BB PORT, int numer_pcf)
{
i2c_start();
i2c_write(numer_pcf);
PORT.byte = i2c_read(0);
i2c_stop();


return PORT.bits.b1; 
}


char sprawdz_pin2(BB PORT, int numer_pcf)
{
i2c_start();
i2c_write(numer_pcf);
PORT.byte = i2c_read(0);
i2c_stop();


return PORT.bits.b2; 
}

char sprawdz_pin3(BB PORT, int numer_pcf)
{
i2c_start();
i2c_write(numer_pcf);
PORT.byte = i2c_read(0);
i2c_stop();


return PORT.bits.b3; 
}

char sprawdz_pin4(BB PORT, int numer_pcf)
{
i2c_start();
i2c_write(numer_pcf);
PORT.byte = i2c_read(0);
i2c_stop();


return PORT.bits.b4; 
}

char sprawdz_pin5(BB PORT, int numer_pcf)
{
i2c_start();
i2c_write(numer_pcf);
PORT.byte = i2c_read(0);
i2c_stop();


return PORT.bits.b5; 
}

char sprawdz_pin6(BB PORT, int numer_pcf)
{
i2c_start();
i2c_write(numer_pcf);
PORT.byte = i2c_read(0);
i2c_stop();


return PORT.bits.b6; 
}

char sprawdz_pin7(BB PORT, int numer_pcf)
{
i2c_start();
i2c_write(numer_pcf);
PORT.byte = i2c_read(0);
i2c_stop();


return PORT.bits.b7; 
}

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



int czekaj_na_guzik_start(int adres)
{
//48 to adres zmiennej 30
//16 to adres zmiennj 10

int z;
z = 0;
putchar(90);
putchar(165);
putchar(4);
putchar(131);
putchar(0);
putchar(adres);  //adres zmiennej - 30
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
//itoa(z,dupa1);       
//lcd_puts(dupa1);

return z;
}




// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Place your code here
//16,384 ms
sek1++;     //Ster 1
sek2++;     //ster 3


sek3++;     //ster 2
sek4++;     //ster 4


//sek10++;

sek11++;  //do wyboru zacisku
sek12++;  //do czasu przedmuchu
}





// Declare your global variables here

void komunikat_na_panel(char flash *fmtstr,int adres2,int adres22)
{
int h;

h = 0;
h = strlenf(fmtstr);
h = h + 3;

putchar(90);
putchar(165);                    
putchar(h);       //ilosc liter 43 + 3
putchar(130);  //82
putchar(adres2);    //
putchar(adres22);  //
printf(fmtstr);
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
putchar(wartosc);   //80
}

void komunikat_z_czytnika_kodow(char flash *fmtstr,int rzad)
{
int h, adres1,adres11,adres2,adres22;

h = 0;
h = strlenf(fmtstr);
h = h + 3;

if(rzad == 1)
   {
   adres1 = 0;
   adres11 = 80;
   adres2 = 80;
   adres22 = 0;
   } 
if(rzad == 2)
   {
   adres1 = 0;
   adres11 = 32;
   adres2 = 64;
   adres22 = 0;
   }

putchar(90);
putchar(165);                    
putchar(h);       //ilosc liter 43 + 3
putchar(130);  //82
putchar(adres1);    //
putchar(adres11);  //
printf(fmtstr);

komunikat_na_panel("                                                ",adres2,adres22);
komunikat_na_panel("Wczytano poprawny zacisk",adres2,adres22);

}




void wyrrrjscia_i_wejscia_opis()
{


//IN0

//komunikacja miedzy slave a master 
//sprawdz_pin0(PORTHH,0x73)  
//sprawdz_pin1(PORTHH,0x73)      
//sprawdz_pin2(PORTHH,0x73)     
//sprawdz_pin3(PORTHH,0x73)      
//sprawdz_pin4(PORTHH,0x73)   
//sprawdz_pin5(PORTHH,0x73)
//sprawdz_pin6(PORTHH,0x73)
//sprawdz_pin7(PORTHH,0x73)   

//IN1
//sprawdz_pin0(PORTJJ,0x79)  BUSY   STEROWNIK1
//sprawdz_pin1(PORTJJ,0x79)  AREA   STEROWNIK1   
//sprawdz_pin2(PORTJJ,0x79)  SETON  STEROWNIK1  
//sprawdz_pin3(PORTJJ,0x79)  INP    STEROWNIK1   
//sprawdz_pin4(PORTJJ,0x79)  SVRE   STEROWNIK1
//sprawdz_pin5(PORTJJ,0x79)  ALARM  STEROWNIK1
//sprawdz_pin6(PORTJJ,0x79)  czujnik cisnienia
//sprawdz_pin7(PORTJJ,0x79)  

//IN2
//sprawdz_pin0(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK3
//sprawdz_pin1(PORTKK,0x75)  B8 AREA    LECP6 STEROWNIK3
//sprawdz_pin2(PORTKK,0x75)  B9 SETON   LECP6 STEROWNIK3
//sprawdz_pin3(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK3
//sprawdz_pin4(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK4 
//sprawdz_pin5(PORTKK,0x75)  B8 AREA    LECP6 STEROWNIK4
//sprawdz_pin6(PORTKK,0x75)  B9 SETON   LECP6 STEROWNIK4
//sprawdz_pin7(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK4 

//IN3
//sprawdz_pin0(PORTLL,0x71)  BUSY   STEROWNIK2
//sprawdz_pin1(PORTLL,0x71)  AREA   STEROWNIK2    
//sprawdz_pin2(PORTLL,0x71)  SETON  STEROWNIK2   
//sprawdz_pin3(PORTLL,0x71)  INP    STEROWNIK2    
//sprawdz_pin4(PORTLL,0x71)  SVRE   STEROWNIK2 
//sprawdz_pin5(PORTLL,0x71)  ALARM  STEROWNIK2
//sprawdz_pin6(PORTLL,0x71)  S6A przek³adanie rzedow
//sprawdz_pin7(PORTLL,0x71)  S6B przekladanie rzedow

//IN4
//sprawdz_pin0(PORTMM,0x77)  
//sprawdz_pin1(PORTMM,0x77)     
//sprawdz_pin2(PORTMM,0x77)     
//sprawdz_pin3(PORTMM,0x77)      
//sprawdz_pin4(PORTMM,0x77)   
//sprawdz_pin5(PORTMM,0x77)
//sprawdz_pin6(PORTMM,0x77) ALARM STEROWNIK4 
//sprawdz_pin7(PORTMM,0x77) ALARM STEROWNIK3  

//KARTA IN4 PRZEPINAM Z PORTE NA PORTF (BO RS232)


//sterownik 1
//sterownik 3 - szczotka papierowa

//sterownik 2 - druciak
///sterownik 4 - druciak


//OUT
//PORTA.0   IN0  STEROWNIK1        OUT 1
//PORTA.1   IN1  STEROWNIK1
//PORTA.2   IN2  STEROWNIK1
//PORTA.3   IN3  STEROWNIK1
//PORTA.4   IN4  STEROWNIK1
//PORTA.5   IN5  STEROWNIK1
//PORTA.6   IN6  STEROWNIK1
//PORTA.7   IN7  STEROWNIK1

//str 83, pin 6 dodac do obu sterownikow


//PORTB.0   IN0  STEROWNIK4        OUT 5
//PORTB.1   IN1  STEROWNIK4
//PORTB.2   IN2  STEROWNIK4
//PORTB.3   IN3  STEROWNIK4         
//PORTB.4   4B CEWKA
//PORTB.5   DRIVE  STEROWNIK4
//PORTB.6   ///////////////////////////////swiatlo zielone
//PORTB.7   IN5 STEROWNIK 3                                                              

//PORTC.0   IN0  STEROWNIK2        OUT 3
//PORTC.1   IN1  STEROWNIK2
//PORTC.2   IN2  STEROWNIK2
//PORTC.3   IN3  STEROWNIK2
//PORTC.4   IN4  STEROWNIK2
//PORTC.5   IN5  STEROWNIK2
//PORTC.6   IN6  STEROWNIK2
//PORTC.7   IN7  STEROWNIK2

//PORTD.0      SDA                 OUT 2
//PORTD.1      SCL
//PORTD.2  SETUP   STEROWNIK1 STEROWNIK 2 STEROIWNIK 3 STEROWNIK 4
//PORTD.3  DRIVE   STEROWNIK1
//PORTD.4  IN8 STEROWNIK1
//PORTD.5  IN8 STEROWNIK2
//PORTD.6  DRIVE   STEROWNIK2
//PORTD.7  ///////////////////////////////swiatlo czerwone

//PORTE.0      
//PORTE.1   
//PORTE.2  1A CEWKA                     OUT 6
//PORTE.3  1B CEWKA 
//PORTE.4  IN4  STEROWNIK4 
//PORTE.5  IN5  STEROWNIK4 
//PORTE.6  2A CEWKA 
//PORTE.7  3A CEWKA   

//PORTF.0   IN0  STEROWNIK3             OUT 4   
//PORTF.1   IN1  STEROWNIK3
//PORTF.2   IN2  STEROWNIK3
//PORTF.3   IN3  STEROWNIK3
//PORTF.4   4A CEWKA           
//PORTF.5   DRIVE  STEROWNIK3
//PORTF.6   /////////////////////////////////swiatlo zolte
//PORTF.7   //IN4 STEROWNIK 3                                                        


//POPRAWIC STEROWNIK PRACE ZGODNIE Z OPISEM ZE STRONY 59 - POWINIENEM SPRAWDZIC CZY INP JEST ON A DOPIERO POTEM BUSY
//CZY SIE WYLACZYL
//FAJNIE ROBIE Z TYM CZEKAIEM 1S

//PODPIAC JESZCZE HOLD WSZYSTKIE DO JEDNEGO


// macierz_zaciskow[rzad]=44; brak

//macierz_zaciskow[rzad]=48; brak

//macierz_zaciskow[rzad]=76  brak  

//komunikat_z_czytnika_kodow("87-2286",rzad); brak
//macierz_zaciskow[rzad]=80;  

// komunikat_z_czytnika_kodow("86-2384",rzad);
// macierz_zaciskow[rzad]=92;  

//  komunikat_z_czytnika_kodow("87-2384",rzad);
//  macierz_zaciskow[rzad]=96;  

//      komunikat_z_czytnika_kodow("86-2028",rzad);
//      macierz_zaciskow[rzad]=107; 

//      komunikat_z_czytnika_kodow("87-2028",rzad);
//      macierz_zaciskow[rzad]=111; 




/*

//testy parzystych i nieparzystych IN0-IN8
//testy port/pin
//sterownik 3
//PORTF.0   IN0  STEROWNIK3   
//PORTF.1   IN1  STEROWNIK3
//PORTF.2   IN2  STEROWNIK3
//PORTF.3   IN3  STEROWNIK3
//PORTF.7   IN4 STEROWNIK 3 
//PORTB.7   IN5 STEROWNIK 3 


PORT_F.bits.b0 = 0;      
PORT_F.bits.b1 = 1;
PORT_F.bits.b2 = 0;
PORT_F.bits.b3 = 1;
PORT_F.bits.b7 = 0;
PORTF = PORT_F.byte;      
PORTB.7 = 1;

//sterownik 4

//PORTB.0   IN0  STEROWNIK4        OUT 5
//PORTB.1   IN1  STEROWNIK4
//PORTB.2   IN2  STEROWNIK4
//PORTB.3   IN3  STEROWNIK4 
//PORTE.4  IN4  STEROWNIK4 
//PORTE.5  IN5  STEROWNIK4

PORTB.0 = 0;
PORTB.1 = 1;
PORTB.2 = 0;
PORTB.3 = 1;
PORTE.4 = 0;
PORTE.5 = 1;

//ster 1
PORTA.0 = 0;   //IN0  STEROWNIK1        OUT 1
PORTA.1 = 1;  //IN1  STEROWNIK1
PORTA.2 = 0;  // IN2  STEROWNIK1
PORTA.3 = 1;  //IN3  STEROWNIK1
PORTA.4 = 0;  // IN4  STEROWNIK1
PORTA.5 = 1;  //IN5  STEROWNIK1
PORTA.6 = 0;   //IN6  STEROWNIK1
PORTA.7 = 1;  //IN7  STEROWNIK1
PORTD.4 = 0; //IN8 STEROWNIK1



//sterownik 2
PORTC.0 = 0;   //IN0  STEROWNIK2        OUT 3
PORTC.1  = 1;  //IN1  STEROWNIK2
PORTC.2 = 0;    //IN2  STEROWNIK2
PORTC.3= 1;   //IN3  STEROWNIK2
PORTC.4 = 0;   // IN4  STEROWNIK2
PORTC.5= 1;   //IN5  STEROWNIK2
PORTC.6 = 0;   // IN6  STEROWNIK2
PORTC.7= 1;   //IN7  STEROWNIK2
PORTD.5 = 0;  //IN8 STEROWNIK2

*/

}

void sprawdz_cisnienie()
{
int i;
//i = 0;
i = 1;

while(i == 0) 
    {
    if(sprawdz_pin6(PORTJJ,0x79) == 0)
        {
        i = 1;
        komunikat_na_panel("                                                ",adr1,adr2);
        }
    else
        {
        i = 0;
        komunikat_na_panel("                                                ",adr1,adr2);
        komunikat_na_panel("Cisnienie za male - mniejsze niz 6 bar",adr1,adr2);
        }
    }    
}

void odczyt_wybranego_zacisku()
{                         //11


PORT_CZYTNIK.bits.b0 = sprawdz_pin0(PORTHH,0x73); 
PORT_CZYTNIK.bits.b1 = sprawdz_pin1(PORTHH,0x73);
PORT_CZYTNIK.bits.b2 = sprawdz_pin2(PORTHH,0x73);
PORT_CZYTNIK.bits.b3 = sprawdz_pin3(PORTHH,0x73);
PORT_CZYTNIK.bits.b4 = sprawdz_pin4(PORTHH,0x73);
PORT_CZYTNIK.bits.b5 = sprawdz_pin5(PORTHH,0x73);
PORT_CZYTNIK.bits.b6 = sprawdz_pin6(PORTHH,0x73);
PORT_CZYTNIK.bits.b7 = sprawdz_pin7(PORTHH,0x73);

rzad = odczytaj_parametr(32,128);       //20,80
                         
if(PORT_CZYTNIK.byte == 0x01)
    {
      komunikat_z_czytnika_kodow("86-0170",rzad);
      macierz_zaciskow[rzad]=1;  
    }

if(PORT_CZYTNIK.byte == 0x02)
    {
      komunikat_z_czytnika_kodow("86-1043",rzad);
      macierz_zaciskow[rzad]=2;  
    }

if(PORT_CZYTNIK.byte == 0x03)
    {
      komunikat_z_czytnika_kodow("86-1675",rzad);
      macierz_zaciskow[rzad]=3;  
    }

if(PORT_CZYTNIK.byte == 0x04)
    {
      komunikat_z_czytnika_kodow("86-2098",rzad);
      macierz_zaciskow[rzad]=4;  
    }
if(PORT_CZYTNIK.byte == 0x05)
    {
      komunikat_z_czytnika_kodow("87-0170",rzad);
      macierz_zaciskow[rzad]=5;  
    }
if(PORT_CZYTNIK.byte == 0x06)
    {
      komunikat_z_czytnika_kodow("87-1043",rzad);
      macierz_zaciskow[rzad]=6;  
    }

if(PORT_CZYTNIK.byte == 0x07)
    {
      komunikat_z_czytnika_kodow("87-1675",rzad);
      macierz_zaciskow[rzad]=7;  
    }

if(PORT_CZYTNIK.byte == 0x08)
    {
      komunikat_z_czytnika_kodow("87-2098",rzad);
      macierz_zaciskow[rzad]=8;  
    }
if(PORT_CZYTNIK.byte == 0x09)
    {
      komunikat_z_czytnika_kodow("86-0192",rzad);
      macierz_zaciskow[rzad]=9;  
    }
if(PORT_CZYTNIK.byte == 0x0A)
    {
      komunikat_z_czytnika_kodow("86-1054",rzad);
      macierz_zaciskow[rzad]=10;  
    }
if(PORT_CZYTNIK.byte == 0x0B)
    {
      komunikat_z_czytnika_kodow("86-1676",rzad);
      macierz_zaciskow[rzad]=11;  
    }
if(PORT_CZYTNIK.byte == 0x0C)
    {
      komunikat_z_czytnika_kodow("86-2132",rzad);
      macierz_zaciskow[rzad]=12;  
    }
if(PORT_CZYTNIK.byte == 0x0D)
    {
      komunikat_z_czytnika_kodow("87-0192",rzad);
      macierz_zaciskow[rzad]=13;  
    }
if(PORT_CZYTNIK.byte == 0x0E)
    {
      komunikat_z_czytnika_kodow("87-1054",rzad);
      macierz_zaciskow[rzad]=14;  
    }

if(PORT_CZYTNIK.byte == 0x0F)
    {
      komunikat_z_czytnika_kodow("87-1676",rzad);
      macierz_zaciskow[rzad]=15;  
    }
if(PORT_CZYTNIK.byte == 0x10)
    {
      komunikat_z_czytnika_kodow("87-2132",rzad);
      macierz_zaciskow[rzad]=16;  
    }

if(PORT_CZYTNIK.byte == 0x11)
    {
      komunikat_z_czytnika_kodow("86-0193",rzad);
      macierz_zaciskow[rzad]=17;  
    }

if(PORT_CZYTNIK.byte == 0x12)
    {
      komunikat_z_czytnika_kodow("86-1216",rzad);
      macierz_zaciskow[rzad]=18;  
    }
if(PORT_CZYTNIK.byte == 0x13)
    {
      komunikat_z_czytnika_kodow("86-1832",rzad);
      macierz_zaciskow[rzad]=19;  
    }

if(PORT_CZYTNIK.byte == 0x14)
    {
      komunikat_z_czytnika_kodow("86-2174",rzad);
      macierz_zaciskow[rzad]=20;  
    }
if(PORT_CZYTNIK.byte == 0x15)
    {
      komunikat_z_czytnika_kodow("87-0193",rzad);
      macierz_zaciskow[rzad]=21;  
    }

if(PORT_CZYTNIK.byte == 0x16)
    {
      komunikat_z_czytnika_kodow("87-1216",rzad);
      macierz_zaciskow[rzad]=22;  
    }
if(PORT_CZYTNIK.byte == 0x17)
    {
      komunikat_z_czytnika_kodow("87-1832",rzad);
      macierz_zaciskow[rzad]=23;  
    }

if(PORT_CZYTNIK.byte == 0x18)
    {
      komunikat_z_czytnika_kodow("87-2174",rzad);
      macierz_zaciskow[rzad]=24;  
    }
if(PORT_CZYTNIK.byte == 0x19)
    {
      komunikat_z_czytnika_kodow("86-0194",rzad);
      macierz_zaciskow[rzad]=25;  
    }

if(PORT_CZYTNIK.byte == 0x1A)
    {
      komunikat_z_czytnika_kodow("86-1341",rzad);
      macierz_zaciskow[rzad]=26;  
    }
if(PORT_CZYTNIK.byte == 0x1B)
    {
      komunikat_z_czytnika_kodow("86-1833",rzad);
      macierz_zaciskow[rzad]=27;  
    }
if(PORT_CZYTNIK.byte == 0x1C)
    {
      komunikat_z_czytnika_kodow("86-2180",rzad);
      macierz_zaciskow[rzad]=28;  
    }
if(PORT_CZYTNIK.byte == 0x1D)
    {
      komunikat_z_czytnika_kodow("87-0194",rzad);
      macierz_zaciskow[rzad]=29;  
    }

if(PORT_CZYTNIK.byte == 0x1E)
    {
      komunikat_z_czytnika_kodow("87-1341",rzad);
      macierz_zaciskow[rzad]=30;  
    }
if(PORT_CZYTNIK.byte == 0x1F)
    {
      komunikat_z_czytnika_kodow("87-1833",rzad);
      macierz_zaciskow[rzad]=31;  
    }

if(PORT_CZYTNIK.byte == 0x20)
    {
      komunikat_z_czytnika_kodow("87-2180",rzad);
      macierz_zaciskow[rzad]=32;  
    }
if(PORT_CZYTNIK.byte == 0x21)
    {
      komunikat_z_czytnika_kodow("86-0663",rzad);
      macierz_zaciskow[rzad]=33;  
    }

if(PORT_CZYTNIK.byte == 0x22)
    {
      komunikat_z_czytnika_kodow("86-1349",rzad);
      macierz_zaciskow[rzad]=34;  
    }
if(PORT_CZYTNIK.byte == 0x23)
    {
      komunikat_z_czytnika_kodow("86-1834",rzad);
      macierz_zaciskow[rzad]=35;  
    }
if(PORT_CZYTNIK.byte == 0x24)
    {
      komunikat_z_czytnika_kodow("86-2204",rzad);
      macierz_zaciskow[rzad]=36;  
    }
if(PORT_CZYTNIK.byte == 0x25)
    {
      komunikat_z_czytnika_kodow("87-0663",rzad);
      macierz_zaciskow[rzad]=37;  
    }
if(PORT_CZYTNIK.byte == 0x26)
    {
      komunikat_z_czytnika_kodow("87-1349",rzad);
      macierz_zaciskow[rzad]=38;  
    }
if(PORT_CZYTNIK.byte == 0x27)
    {
      komunikat_z_czytnika_kodow("87-1834",rzad);
      macierz_zaciskow[rzad]=39;  
    }
if(PORT_CZYTNIK.byte == 0x28)
    {
      komunikat_z_czytnika_kodow("87-2204",rzad);
      macierz_zaciskow[rzad]=40;  
    }
if(PORT_CZYTNIK.byte == 0x29)
    {
      komunikat_z_czytnika_kodow("86-0768",rzad);
      macierz_zaciskow[rzad]=41;  
    }
if(PORT_CZYTNIK.byte == 0x2A)
    {
      komunikat_z_czytnika_kodow("86-1357",rzad);
      macierz_zaciskow[rzad]=42;  
    }
if(PORT_CZYTNIK.byte == 0x2B)
    {
      komunikat_z_czytnika_kodow("86-1848",rzad);
      macierz_zaciskow[rzad]=43;  
    }
if(PORT_CZYTNIK.byte == 0x2C)
    {
      komunikat_z_czytnika_kodow("86-2212",rzad);
      macierz_zaciskow[rzad]=44;  
    }
if(PORT_CZYTNIK.byte == 0x2D)
    {
      komunikat_z_czytnika_kodow("87-0768",rzad);
      macierz_zaciskow[rzad]=45;  
    }
if(PORT_CZYTNIK.byte == 0x2E)
    {
      komunikat_z_czytnika_kodow("87-1357",rzad);
      macierz_zaciskow[rzad]=46;  
    }
if(PORT_CZYTNIK.byte == 0x2F)
    {
      komunikat_z_czytnika_kodow("87-1848",rzad);
      macierz_zaciskow[rzad]=47;  
    }
if(PORT_CZYTNIK.byte == 0x30)
    {
      komunikat_z_czytnika_kodow("87-2212",rzad);
      macierz_zaciskow[rzad]=48;  
    }
if(PORT_CZYTNIK.byte == 0x31)
    {
      komunikat_z_czytnika_kodow("86-0800",rzad);
      macierz_zaciskow[rzad]=49;  
    }
if(PORT_CZYTNIK.byte == 0x32)
    {
      komunikat_z_czytnika_kodow("86-1363",rzad);
      macierz_zaciskow[rzad]=50;  
    }
if(PORT_CZYTNIK.byte == 0x33)
    {
      komunikat_z_czytnika_kodow("86-1904",rzad);
      macierz_zaciskow[rzad]=51;  
    }
if(PORT_CZYTNIK.byte == 0x34)
    {
      komunikat_z_czytnika_kodow("86-2241",rzad);
      macierz_zaciskow[rzad]=52;  
    }
if(PORT_CZYTNIK.byte == 0x35)
    {
      komunikat_z_czytnika_kodow("87-0800",rzad);
      macierz_zaciskow[rzad]=53;  
    }

if(PORT_CZYTNIK.byte == 0x36)
    {
      komunikat_z_czytnika_kodow("87-1363",rzad);
      macierz_zaciskow[rzad]=54;  
    }
if(PORT_CZYTNIK.byte == 0x37)
    {
      komunikat_z_czytnika_kodow("87-1904",rzad);
      macierz_zaciskow[rzad]=55;  
    }
if(PORT_CZYTNIK.byte == 0x38)
    {
      komunikat_z_czytnika_kodow("87-2241",rzad);
      macierz_zaciskow[rzad]=56;  
    }
if(PORT_CZYTNIK.byte == 0x39)
    {
      komunikat_z_czytnika_kodow("86-0811",rzad);
      macierz_zaciskow[rzad]=57;  
    }
if(PORT_CZYTNIK.byte == 0x3A)
    {
      komunikat_z_czytnika_kodow("86-1523",rzad);
      macierz_zaciskow[rzad]=58;  
    }
if(PORT_CZYTNIK.byte == 0x3B)
    {
      komunikat_z_czytnika_kodow("86-1929",rzad);
      macierz_zaciskow[rzad]=59;  
    }
if(PORT_CZYTNIK.byte == 0x3C)
    {
      komunikat_z_czytnika_kodow("86-2261",rzad);
      macierz_zaciskow[rzad]=60;  
    }
if(PORT_CZYTNIK.byte == 0x3D)
    {
      komunikat_z_czytnika_kodow("87-0811",rzad);
      macierz_zaciskow[rzad]=61;  
    }
if(PORT_CZYTNIK.byte == 0x3E)
    {
      komunikat_z_czytnika_kodow("87-1523",rzad);
      macierz_zaciskow[rzad]=62;  
    }
if(PORT_CZYTNIK.byte == 0x3F)
    {
      komunikat_z_czytnika_kodow("87-1929",rzad);
      macierz_zaciskow[rzad]=63;  
    }
if(PORT_CZYTNIK.byte == 0x40)
    {
      komunikat_z_czytnika_kodow("87-2261",rzad);
      macierz_zaciskow[rzad]=64;  
    }
if(PORT_CZYTNIK.byte == 0x41)
    {
      komunikat_z_czytnika_kodow("86-0814",rzad);
      macierz_zaciskow[rzad]=65;  
    }
if(PORT_CZYTNIK.byte == 0x42)
    {
      komunikat_z_czytnika_kodow("86-1530",rzad);
      macierz_zaciskow[rzad]=66;  
    }
if(PORT_CZYTNIK.byte == 0x43)
    {
      komunikat_z_czytnika_kodow("86-1936",rzad);
      macierz_zaciskow[rzad]=67;  
    }
if(PORT_CZYTNIK.byte == 0x44)
    {
      komunikat_z_czytnika_kodow("86-2285",rzad);
      macierz_zaciskow[rzad]=68;  
    }
if(PORT_CZYTNIK.byte == 0x45)
    {
      komunikat_z_czytnika_kodow("87-0814",rzad);
      macierz_zaciskow[rzad]=69;  
    }
if(PORT_CZYTNIK.byte == 0x46)
    {
      komunikat_z_czytnika_kodow("87-1530",rzad);
      macierz_zaciskow[rzad]=70;  
    }
if(PORT_CZYTNIK.byte == 0x47)
    {
      komunikat_z_czytnika_kodow("87-1936",rzad);
      macierz_zaciskow[rzad]=71;  
    }
if(PORT_CZYTNIK.byte == 0x48)
    {
      komunikat_z_czytnika_kodow("87-2285",rzad);
      macierz_zaciskow[rzad]=72;  
    }
if(PORT_CZYTNIK.byte == 0x49)
    {
      komunikat_z_czytnika_kodow("86-0815",rzad);
      macierz_zaciskow[rzad]=73;  
    }

if(PORT_CZYTNIK.byte == 0x4A)
    {
      komunikat_z_czytnika_kodow("86-1551",rzad);
      macierz_zaciskow[rzad]=74;  
    }
if(PORT_CZYTNIK.byte == 0x4B)
    {
      komunikat_z_czytnika_kodow("86-1941",rzad);
      macierz_zaciskow[rzad]=75;  
    }
if(PORT_CZYTNIK.byte == 0x4C)
    {
      komunikat_z_czytnika_kodow("86-2286",rzad);
      macierz_zaciskow[rzad]=76;  
    }
if(PORT_CZYTNIK.byte == 0x4D)
    {
      komunikat_z_czytnika_kodow("87-0815",rzad);
      macierz_zaciskow[rzad]=77;  
    }
if(PORT_CZYTNIK.byte == 0x4E)
    {
      komunikat_z_czytnika_kodow("87-1551",rzad);
      macierz_zaciskow[rzad]=78;  
    }
if(PORT_CZYTNIK.byte == 0x4F)
    {
      komunikat_z_czytnika_kodow("87-1941",rzad);
      macierz_zaciskow[rzad]=79;  
    }
if(PORT_CZYTNIK.byte == 0x50)
    {
      komunikat_z_czytnika_kodow("87-2286",rzad);
      macierz_zaciskow[rzad]=80;  
    }
if(PORT_CZYTNIK.byte == 0x51)
    {
      komunikat_z_czytnika_kodow("86-0816",rzad);
      macierz_zaciskow[rzad]=81;  
    }
if(PORT_CZYTNIK.byte == 0x52)
    {
      komunikat_z_czytnika_kodow("86-1552",rzad);
      macierz_zaciskow[rzad]=82;  
    }
if(PORT_CZYTNIK.byte == 0x53)
    {
      komunikat_z_czytnika_kodow("86-2007",rzad);
      macierz_zaciskow[rzad]=83;  
    }
if(PORT_CZYTNIK.byte == 0x54)
    {
      komunikat_z_czytnika_kodow("86-2292",rzad);
      macierz_zaciskow[rzad]=84;  
    }
if(PORT_CZYTNIK.byte == 0x55)
    {
      komunikat_z_czytnika_kodow("87-0816",rzad);
      macierz_zaciskow[rzad]=85;  
     }
if(PORT_CZYTNIK.byte == 0x56)
    {
      komunikat_z_czytnika_kodow("87-1552",rzad);
      macierz_zaciskow[rzad]=86;  
    }
if(PORT_CZYTNIK.byte == 0x57)
    {
      komunikat_z_czytnika_kodow("87-2007",rzad);
      macierz_zaciskow[rzad]=87;  
    }
if(PORT_CZYTNIK.byte == 0x58)
    {
      komunikat_z_czytnika_kodow("87-2292",rzad);
      macierz_zaciskow[rzad]=88;  
    }
if(PORT_CZYTNIK.byte == 0x59)
    {
      komunikat_z_czytnika_kodow("86-0817",rzad);
      macierz_zaciskow[rzad]=89;
    }  
if(PORT_CZYTNIK.byte == 0x5A)
    {
      komunikat_z_czytnika_kodow("86-1602",rzad);
      macierz_zaciskow[rzad]=90;  
    }
if(PORT_CZYTNIK.byte == 0x5B)
    {
      komunikat_z_czytnika_kodow("86-2017",rzad);
      macierz_zaciskow[rzad]=91;  
    }
if(PORT_CZYTNIK.byte == 0x5C)
    {
      komunikat_z_czytnika_kodow("86-2384",rzad);
      macierz_zaciskow[rzad]=92;  
    }
if(PORT_CZYTNIK.byte == 0x5D)
    {
      komunikat_z_czytnika_kodow("87-0817",rzad);
      macierz_zaciskow[rzad]=93;  
    }
if(PORT_CZYTNIK.byte == 0x5E)
    {
      komunikat_z_czytnika_kodow("87-1602",rzad);
      macierz_zaciskow[rzad]=94;  
    }
if(PORT_CZYTNIK.byte == 0x5F)
    {
      komunikat_z_czytnika_kodow("87-2017",rzad);
      macierz_zaciskow[rzad]=95;  
    }
if(PORT_CZYTNIK.byte == 0x60)
    {
      komunikat_z_czytnika_kodow("87-2384",rzad);
      macierz_zaciskow[rzad]=96;  
    }

if(PORT_CZYTNIK.byte == 0x61)
    {
      komunikat_z_czytnika_kodow("86-0847",rzad);
      macierz_zaciskow[rzad]=97;  
    }

if(PORT_CZYTNIK.byte == 0x62)
    {
      komunikat_z_czytnika_kodow("86-1620",rzad);
      macierz_zaciskow[rzad]=98;  
    }
if(PORT_CZYTNIK.byte == 0x63)
    {
      komunikat_z_czytnika_kodow("86-2019",rzad);
      macierz_zaciskow[rzad]=99;  
    }
if(PORT_CZYTNIK.byte == 0x64)
    {
      komunikat_z_czytnika_kodow("86-2385",rzad);
      macierz_zaciskow[rzad]=100;  
    }
if(PORT_CZYTNIK.byte == 0x65)
    {
      komunikat_z_czytnika_kodow("87-0847",rzad);
      macierz_zaciskow[rzad]=101;  
    }
if(PORT_CZYTNIK.byte == 0x66)
    {
      komunikat_z_czytnika_kodow("87-1620",rzad);
      macierz_zaciskow[rzad]=102;  
    }
if(PORT_CZYTNIK.byte == 0x67)
    {
      komunikat_z_czytnika_kodow("87-2019",rzad);
      macierz_zaciskow[rzad]=103;  
    }
if(PORT_CZYTNIK.byte == 0x68)
    {
      komunikat_z_czytnika_kodow("87-2385",rzad);
      macierz_zaciskow[rzad]=104;  
    }
if(PORT_CZYTNIK.byte == 0x69)
    {
      komunikat_z_czytnika_kodow("86-0854",rzad);
      macierz_zaciskow[rzad]=105;  
    }
if(PORT_CZYTNIK.byte == 0x6A)
    {
      komunikat_z_czytnika_kodow("86-1622",rzad);
      macierz_zaciskow[rzad]=106;  
    }
if(PORT_CZYTNIK.byte == 0x6B)
    {
      komunikat_z_czytnika_kodow("86-2028",rzad);
      macierz_zaciskow[rzad]=107;  
    }
if(PORT_CZYTNIK.byte == 0x6C)
    {
      komunikat_z_czytnika_kodow("86-2437",rzad);
      macierz_zaciskow[rzad]=108;  
    }
if(PORT_CZYTNIK.byte == 0x6D)
    {
      komunikat_z_czytnika_kodow("87-0854",rzad);
      macierz_zaciskow[rzad]=109;  
    }
if(PORT_CZYTNIK.byte == 0x6E)
    {
      komunikat_z_czytnika_kodow("87-1622",rzad);
      macierz_zaciskow[rzad]=110;  
    }

if(PORT_CZYTNIK.byte == 0x6F)
    {
      komunikat_z_czytnika_kodow("87-2028",rzad);
      macierz_zaciskow[rzad]=111;  
    }

if(PORT_CZYTNIK.byte == 0x70)
    {
      komunikat_z_czytnika_kodow("87-2437",rzad);
      macierz_zaciskow[rzad]=112;  
    }
if(PORT_CZYTNIK.byte == 0x71)
    {
      komunikat_z_czytnika_kodow("86-0862",rzad);
      macierz_zaciskow[rzad]=113;  
    }
if(PORT_CZYTNIK.byte == 0x72)
    {
      komunikat_z_czytnika_kodow("86-1625",rzad);
      macierz_zaciskow[rzad]=114;  
    }
if(PORT_CZYTNIK.byte == 0x73)
    {
      komunikat_z_czytnika_kodow("86-2052",rzad);
      macierz_zaciskow[rzad]=115;  
    }
if(PORT_CZYTNIK.byte == 0x74)
    {
      komunikat_z_czytnika_kodow("86-2492",rzad);
      macierz_zaciskow[rzad]=116;  
    }
if(PORT_CZYTNIK.byte == 0x75)
    {
      komunikat_z_czytnika_kodow("87-0862",rzad);
      macierz_zaciskow[rzad]=117;  
    }
if(PORT_CZYTNIK.byte == 0x76)
    {
      komunikat_z_czytnika_kodow("87-1625",rzad);
      macierz_zaciskow[rzad]=118;  
    }
if(PORT_CZYTNIK.byte == 0x77)
    {
      komunikat_z_czytnika_kodow("87-2052",rzad);
      macierz_zaciskow[rzad]=119;  
    }
if(PORT_CZYTNIK.byte == 0x78)
    {
      komunikat_z_czytnika_kodow("87-2492",rzad);
      macierz_zaciskow[rzad]=120;  
    }
if(PORT_CZYTNIK.byte == 0x79)
    {
      komunikat_z_czytnika_kodow("86-0935",rzad);
      macierz_zaciskow[rzad]=121;  
    }
if(PORT_CZYTNIK.byte == 0x7A)
    {
      komunikat_z_czytnika_kodow("86-1648",rzad);
      macierz_zaciskow[rzad]=122;  
    }
if(PORT_CZYTNIK.byte == 0x7B)
    {
      komunikat_z_czytnika_kodow("86-2082",rzad);
      macierz_zaciskow[rzad]=123;  
    }
if(PORT_CZYTNIK.byte == 0x7C)
    {
      komunikat_z_czytnika_kodow("86-2500",rzad);
      macierz_zaciskow[rzad]=124;  
    }
if(PORT_CZYTNIK.byte == 0x7D)
    {
      komunikat_z_czytnika_kodow("87-0935",rzad);
      macierz_zaciskow[rzad]=125;  
    }
if(PORT_CZYTNIK.byte == 0x7E)
    {
      komunikat_z_czytnika_kodow("87-1648",rzad);
      macierz_zaciskow[rzad]=126;  
    }

if(PORT_CZYTNIK.byte == 0x7F)
    {
      komunikat_z_czytnika_kodow("87-2082",rzad);
      macierz_zaciskow[rzad]=127;  
    }
if(PORT_CZYTNIK.byte == 0x80)
    {
      komunikat_z_czytnika_kodow("87-2500",rzad);
      macierz_zaciskow[rzad]=128;  
    }
if(PORT_CZYTNIK.byte == 0x81)
    {
      komunikat_z_czytnika_kodow("86-1019",rzad);
      macierz_zaciskow[rzad]=129;  
    }
if(PORT_CZYTNIK.byte == 0x82)
    {
      komunikat_z_czytnika_kodow("86-1649",rzad);
      macierz_zaciskow[rzad]=130;  
    }
if(PORT_CZYTNIK.byte == 0x83)
    {
      komunikat_z_czytnika_kodow("86-2083",rzad);
      macierz_zaciskow[rzad]=131;  
    }
if(PORT_CZYTNIK.byte == 0x84)
    {
      komunikat_z_czytnika_kodow("86-2585",rzad);
      macierz_zaciskow[rzad]=132;  
    }
if(PORT_CZYTNIK.byte == 0x85)
    {
      komunikat_z_czytnika_kodow("87-1019",rzad);
      macierz_zaciskow[rzad]=133;  
    }
if(PORT_CZYTNIK.byte == 0x86)
    {
      komunikat_z_czytnika_kodow("87-1649",rzad);
      macierz_zaciskow[rzad]=134;  
    }
if(PORT_CZYTNIK.byte == 0x87)
    {
      komunikat_z_czytnika_kodow("87-2083",rzad);
      macierz_zaciskow[rzad]=135;  
    }

if(PORT_CZYTNIK.byte == 0x88)
    {
      komunikat_z_czytnika_kodow("87-2624",rzad);
      macierz_zaciskow[rzad]=136;  
    }
if(PORT_CZYTNIK.byte == 0x89)
    {
      komunikat_z_czytnika_kodow("86-1027",rzad);
      macierz_zaciskow[rzad]=137;  
    }
if(PORT_CZYTNIK.byte == 0x8A)
    {
      komunikat_z_czytnika_kodow("86-1669",rzad);
      macierz_zaciskow[rzad]=138;  
    }
if(PORT_CZYTNIK.byte == 0x8B)
    {
      komunikat_z_czytnika_kodow("86-2087",rzad);
      macierz_zaciskow[rzad]=139;  
    }
if(PORT_CZYTNIK.byte == 0x8C)
    {
      komunikat_z_czytnika_kodow("86-2624",rzad);
      macierz_zaciskow[rzad]=140;  
    }
if(PORT_CZYTNIK.byte == 0x8D)
    {
      komunikat_z_czytnika_kodow("87-1027",rzad);
      macierz_zaciskow[rzad]=141;  
    }
if(PORT_CZYTNIK.byte == 0x8E)
    {
      komunikat_z_czytnika_kodow("87-1669",rzad);
      macierz_zaciskow[rzad]=142;  
    }
if(PORT_CZYTNIK.byte == 0x8F)
    {
      komunikat_z_czytnika_kodow("87-2087",rzad);
      macierz_zaciskow[rzad]=143;  
    }
if(PORT_CZYTNIK.byte == 0x90)
    {
      komunikat_z_czytnika_kodow("87-2585",rzad);
      macierz_zaciskow[rzad]=144;  
    }
}


void wybor_linijek_sterownikow()
{
//zaczynam od tego
//86-1349

switch(macierz_zaciskow[1])
    {
    case 0:
           
            komunikat_na_panel("                                                ",adr1,adr2);
            komunikat_na_panel("Nie wczytano zacisku",adr1,adr2);
    
    break;
    
    
    case 34:
            
            a[0] = 0x5A;       
            a[1] = 0;
            a[2] = 0x5B;
            a[3] = 0;;
    
    break;
    
    
    
    
    }



switch(macierz_zaciskow[2])
    {
    case 0:
           
            komunikat_na_panel("                                                ",adr3,adr4);
            komunikat_na_panel("Nie wczytano zacisku",adr1,adr2);
    
    break;
    }

}

void wypozycjonuj_napedy_minimalistyczna()
{
PORTD.2 = 1;   //setup wspolny
delay_ms(1000);

while(sprawdz_pin3(PORTJJ,0x79) == 1 | sprawdz_pin3(PORTLL,0x71) == 1 |
      sprawdz_pin3(PORTKK,0x75) == 1 | sprawdz_pin7(PORTKK,0x75) == 1)
      {
      komunikat_na_panel("                                                ",adr1,adr2);
      komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr1,adr2);
      komunikat_na_panel("                                                ",adr3,adr4);
      komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr3,adr4);
      delay_ms(1000);
      
      if(sprawdz_pin3(PORTJJ,0x79) == 0)
            {
            komunikat_na_panel("                                                ",adr1,adr2);
            komunikat_na_panel("Sterownik 1 - wypozycjonowalem",adr1,adr2);
            delay_ms(1000);
            }
      if(sprawdz_pin3(PORTLL,0x71) == 0)      
            {
            komunikat_na_panel("                                                ",adr3,adr4);
            komunikat_na_panel("Sterownik 2 - wypozycjonowalem",adr3,adr4);
            delay_ms(1000);
            }
      if(sprawdz_pin3(PORTKK,0x75) == 0)      
            {
            komunikat_na_panel("                                                ",adr1,adr2);
            komunikat_na_panel("Sterownik 3 - wypozycjonowalem",adr1,adr2);
            delay_ms(1000);
            }
      if(sprawdz_pin7(PORTKK,0x75) == 0)      
            {
            komunikat_na_panel("                                                ",adr3,adr4);
            komunikat_na_panel("Sterownik 4 - wypozycjonowalem",adr1,adr2);
            delay_ms(1000);
            }
            
            
      }  

komunikat_na_panel("                                                ",adr1,adr2);
komunikat_na_panel("Wypozycjonowano uklady liniowe XYZ",adr1,adr2);
komunikat_na_panel("                                                ",adr3,adr4);
komunikat_na_panel("Wypozycjonowano uklady liniowe XYZ",adr3,adr4);

PORTD.2 = 0;   //setup wspolny
delay_ms(1000);

}

int wypozycjonuj_LEFS32_300_1(int step)
{
//PORTF.0   IN0  STEROWNIK3   
//PORTF.1   IN1  STEROWNIK3
//PORTF.2   IN2  STEROWNIK3
//PORTF.3   IN3  STEROWNIK3

//PORTF.4   SETUP  STEROWNIK3
//PORTF.5   DRIVE  STEROWNIK3

//sprawdz_pin0(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK3
//sprawdz_pin3(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK3


if(step == 0)
{      
switch(pozycjonowanie_LEFS32_300_1)
    {
    case 0:
            PORT_F.bits.b4 = 1;      // ////A9  SETUP
            PORTF = PORT_F.byte;    
            
            if(sprawdz_pin0(PORTKK,0x75) == 1)  //BUSY
                {
                }
            else
                {
                pozycjonowanie_LEFS32_300_1 = 1;
                }
    
    break;
    
    case 1:
            if(sprawdz_pin0(PORTKK,0x75) == 0)
                {
                }
            else
                {
                pozycjonowanie_LEFS32_300_1 = 2;
                }
            if(sprawdz_pin7(PORTMM,0x77) == 1)     //alarm
                   {
                   komunikat_na_panel("                                                ",adr1,adr2);
                   komunikat_na_panel("Przeciazenia LEFS32_1",adr1,adr2);
                   }
    
    break;
    
    case 2:  
    
            if(sprawdz_pin3(PORTKK,0x75) == 1)
                {
                }
            else
                {
                pozycjonowanie_LEFS32_300_1 = 3;
                }
             if(sprawdz_pin7(PORTMM,0x77) == 1)     //alarm
                   {
                   komunikat_na_panel("                                                ",adr1,adr2);
                   komunikat_na_panel("Przeciazenia LEFS32_1",adr1,adr2);
                   }
    
    break;
    
    case 3:
            
            if(sprawdz_pin3(PORTKK,0x75) == 0)
                {
                PORT_F.bits.b4 = 0;      // ////A9  SETUP
                PORTF = PORT_F.byte;
                pozycjonowanie_LEFS32_300_1 = 4;
              
                }
    
    break;
    
    }
}



if(step == 1)
{
while(cykl < 5)
{
    switch(cykl)
        {
        case 0:
        
            PORTE.7 = 1;  ////////////////////////////////////////////////////////////////////czasowo aby pokazac
            sek2 = 0;
            PORT_F.bits.b0 = 1;
            PORT_F.bits.b1 = 1;         //STEP 0
            PORT_F.bits.b2 = 1;
            PORT_F.bits.b3 = 1;
            PORTF = PORT_F.byte;      
            cykl = 1;
            
                 
        break;
        
        case 1:
        
            if(sek2 > 1)
                {
                PORT_F.bits.b5 = 1;
                PORTF = PORT_F.byte;
                cykl = 2;
                delay_ms(1000);
                }
        break;
        
        
        case 2:
    
               if(sprawdz_pin0(PORTKK,0x75) == 0)
                  {
                  PORT_F.bits.b5 = 0;
                  PORTF = PORT_F.byte;       //DRIVE koniec
                  
                  PORT_F.bits.b0 = 0;
                  PORT_F.bits.b1 = 0;         //STEP 1 koniec
                  PORT_F.bits.b2 = 0;
                  PORT_F.bits.b3 = 0;
                  PORTF = PORT_F.byte;    
                  
                  delay_ms(1000);
                  cykl = 3;
                  }
    
        break;
    
        case 3:
    
               if(sprawdz_pin3(PORTKK,0x75) == 0)
                  {
                  sek2 = 0;
                  cykl = 4;
                  }
              if(sprawdz_pin7(PORTMM,0x77) == 1)     //alarm
                   {
                   komunikat_na_panel("                                                ",adr1,adr2);
                   komunikat_na_panel("Przeciazenia LEFS32_1",adr1,adr2);
                   }
               
        break;
        
        
        case 4:
        
            if(sek2 > 50)
                {
                cykl = 5;
                }
        break;
        
        }
}

cykl = 0;
}





if(step == 0 & pozycjonowanie_LEFS32_300_1 == 4)
    {
    pozycjonowanie_LEFS32_300_1 = 0;
    cykl = 0;
    return 1;
    }
if(step == 1)
    return 2;



}


int wypozycjonuj_LEFS32_300_2(int step)
{
//PORTB.0   IN0  STEROWNIK4   
//PORTB.1   IN1  STEROWNIK4
//PORTB.2   IN2  STEROWNIK4
//PORTB.3   IN3  STEROWNIK4

//PORTB.4   SETUP  STEROWNIK4
//PORTB.5   DRIVE  STEROWNIK4

//sprawdz_pin4(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK4
//sprawdz_pin7(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK4 


if(step == 0)
{      
switch(pozycjonowanie_LEFS32_300_2)
    {
    case 0:
            PORTB.4 = 1;      // ////A9  SETUP
                
            if(sprawdz_pin4(PORTKK,0x75) == 1)  //BUSY
                {
                }
            else
                pozycjonowanie_LEFS32_300_2 = 1;
    
    break;
    
    case 1:
            if(sprawdz_pin4(PORTKK,0x75) == 0)
                {
                }
            else
                pozycjonowanie_LEFS32_300_2 = 2;
             
             if(sprawdz_pin6(PORTMM,0x77) == 1)     //alarm
                   {
                   komunikat_na_panel("                                                ",adr1,adr2);
                   komunikat_na_panel("Przeciazenia LEFS32_2",adr3,adr4);
                   }
    
    break;
    
    case 2:  
    
            if(sprawdz_pin7(PORTKK,0x75) == 1)
                {
                }
            else
                pozycjonowanie_LEFS32_300_2 = 3;
            
            if(sprawdz_pin6(PORTMM,0x77) == 1)     //alarm
                   {
                   komunikat_na_panel("                                                ",adr1,adr2);
                   komunikat_na_panel("Przeciazenia LEFS32_2",adr3,adr4);
                   }
    
    break;
    
    case 3:
            
            if(sprawdz_pin7(PORTKK,0x75) == 0)
                {
                PORTB.4 = 0;      // ////A9  SETUP
                
                pozycjonowanie_LEFS32_300_2 = 4;
                }
    
    break;
    
    }
}

if(step == 1)
{
while(cykl < 5)
{
    switch(cykl)
        {
        case 0:
        
            sek4 = 0;
            PORTB.0 = 1;    //STEP 0
            PORTB.1 = 1;
            PORTB.2 = 1;
            PORTB.3 = 1;
            
            cykl = 1;
            
                 
        break;
        
        case 1:
        
            if(sek4 > 1)
                {
                PORTB.5 = 1;
                cykl = 2;
                delay_ms(1000);
                }
        break;
        
        
        case 2:
    
               if(sprawdz_pin4(PORTKK,0x75) == 0)
                  {
                  PORTB.5 = 0;
                      //DRIVE koniec
                  
                  PORTB.0 = 0;    //STEP 0
                  PORTB.1 = 0;
                  PORTB.2 = 0;
                  PORTB.3 = 0;
                     
                  
                  delay_ms(1000);
                  cykl = 3;
                  }
    
        break;
    
        case 3:
    
               if(sprawdz_pin7(PORTKK,0x75) == 0)
                  {
                  sek4 = 0;
                  cykl = 4;
                  }
               if(sprawdz_pin6(PORTMM,0x77) == 1)     //alarm
                   {
                   komunikat_na_panel("                                                ",adr1,adr2);
                   komunikat_na_panel("Przeciazenia LEFS32_2",adr3,adr4);
                   }
               
               
        break;
        
        
        case 4:
        
            if(sek4 > 50)
                cykl = 5;
        break;
        
        }
}

cykl = 0;
}

if(step == 0 & pozycjonowanie_LEFS32_300_2 == 4)
    {
    pozycjonowanie_LEFS32_300_2 = 0;
    cykl = 0;
    return 1;
    }
if(step == 1)
    return 2;

}






int wypozycjonuj_LEFS40_1200_2_i_300_2()
{
//PORTC.0   IN0  STEROWNIK2   
//PORTC.1   IN1  STEROWNIK2
//PORTC.2   IN2  STEROWNIK2
//PORTC.3   IN3  STEROWNIK2
//PORTC.4   IN4  STEROWNIK2
//PORTC.5   IN5  STEROWNIK2
//PORTC.6   IN6  STEROWNIK2
//PORTC.7   IN7  STEROWNIK2

//PORTD.5  SETUP   STEROWNIK2
//PORTD.6  DRIVE   STEROWNIK2

//sprawdz_pin0(PORTLL,0x71)  BUSY   STEROWNIK2
//sprawdz_pin3(PORTLL,0x71)  INP    STEROWNIK2

PORTD.5 = 1;    //SETUP

delay_ms(50);

while(sprawdz_pin0(PORTLL,0x71) == 1)  //kraze tu poki nie wywali busy
        {
          
                   if(sprawdz_pin5(PORTLL,0x71) == 1)     //alarm
                   {
                   komunikat_na_panel("                                                ",adr1,adr2);
                   komunikat_na_panel("Przeciazenia LEFS_XY_2",adr3,adr4);
                   }
        
        }

delay_ms(50);

while(sprawdz_pin0(PORTLL,0x71) == 0)  //wywala busy
        {
          
                   if(sprawdz_pin5(PORTLL,0x71) == 1)     //alarm
                   {
                   komunikat_na_panel("                                                ",adr1,adr2);
                   komunikat_na_panel("Przeciazenia LEFS_XY_2",adr3,adr4);
                   }
        }

delay_ms(50);

while(sprawdz_pin3(PORTLL,0x71) == 1)  //kraze tu dopoki nie wywali INP
        {
        }

delay_ms(50);

if(sprawdz_pin3(PORTLL,0x71) == 0)  //wywala INP
        {
        PORTD.5 = 0;
        putchar(90);  //5A
        putchar(165); //A5
        putchar(3);//03  //znak dzwiekowy ze jestem
        putchar(128);  //80
        putchar(2);    //02
        putchar(16);   //10
        }
else
    {
        putchar(90);  //5A
        putchar(165); //A5
        putchar(3);//03  //znak dzwiekowy ze jestem
        putchar(128);  //80
        putchar(2);    //02
        putchar(16);   //10
        
        delay_ms(1000);     //wywalenie bledu
        delay_ms(1000);
        
        putchar(90);  //5A
        putchar(165); //A5
        putchar(3);//03  //znak dzwiekowy ze jestem
        putchar(128);  //80
        putchar(2);    //02
        putchar(16);   //10
    
    }

delay_ms(1000);

while(cykl < 5)
{
    switch(cykl)
        {
        case 0:
        
            PORTC = 0xFF;   //STEP 0
            cykl = 1;
        
        break;
        
        case 1:
        
            if(sek3 > 1)
                {
                PORTD.6 = 1;  //DRIVE
                cykl = 2;
                }
        break;
        
        
        case 2:
    
               if(sprawdz_pin0(PORTLL,0x71) == 0)
                  {
                  PORTD.6 = 0;
                  PORTC = 0x00;        //STEP 1 koniec
                  cykl = 3;
                  }
    
        break;
    
        case 3:
    
               if(sprawdz_pin3(PORTLL,0x71) == 0)
                  {
                  sek3 = 0;
                  cykl = 4;
                  }
                  
                   if(sprawdz_pin5(PORTLL,0x71) == 1)     //alarm
                   {
                   komunikat_na_panel("                                                ",adr1,adr2);
                   komunikat_na_panel("Przeciazenia LEFS_XY_2",adr3,adr4);
                   }
               
               
        break;
        
        
        case 4:
        
            if(sek3 > 50)
                cykl = 5;
        break;
        
        }
}

cykl = 0;
return 1;
}




int wypozycjonuj_LEFS40_1200_1_i_300_1()
{
//chyba nie wpiete A7

//PORTA.0   IN0  STEROWNIK1   
//PORTA.1   IN1  STEROWNIK1
//PORTA.2   IN2  STEROWNIK1
//PORTA.3   IN3  STEROWNIK1
//PORTA.4   IN4  STEROWNIK1
//PORTA.5   IN5  STEROWNIK1
//PORTA.6   IN6  STEROWNIK1
//PORTA.7   IN7  STEROWNIK1

//PORTD.2  SETUP   STEROWNIK1
//PORTD.3  DRIVE   STEROWNIK1

//sprawdz_pin0(PORTJJ,0x79)  BUSY   STEROWNIK1
//sprawdz_pin3(PORTJJ,0x79)  INP    STEROWNIK1 

PORTD.2 = 1;    //SETUP

delay_ms(50);

while(sprawdz_pin0(PORTJJ,0x79) == 1)  //kraze tu poki nie wywali busy
        {
            if(sprawdz_pin5(PORTJJ,0x79) == 1)     //alarm
                   {
                   komunikat_na_panel("                                                ",adr1,adr2);
                   komunikat_na_panel("Przeciazenia LEFS_XY_1",adr1,adr2);
                   }
        }

delay_ms(50);

while(sprawdz_pin0(PORTJJ,0x79) == 0)  //wywala busy
        {
            if(sprawdz_pin5(PORTJJ,0x79) == 1)     //alarm
                   {
                   komunikat_na_panel("                                                ",adr1,adr2);
                   komunikat_na_panel("Przeciazenia LEFS_XY_1",adr1,adr2);
                   }
        
        }

delay_ms(50);

while(sprawdz_pin3(PORTJJ,0x79) == 1)  //kraze tu dopoki nie wywali INP
        {
        }

delay_ms(50);

if(sprawdz_pin3(PORTJJ,0x79) == 0)  //wywala INP
        {
        PORTD.2 = 0;
        putchar(90);  //5A
        putchar(165); //A5
        putchar(3);//03  //znak dzwiekowy ze jestem
        putchar(128);  //80
        putchar(2);    //02
        putchar(16);   //10
        }
else
    {
        putchar(90);  //5A
        putchar(165); //A5
        putchar(3);//03  //znak dzwiekowy ze jestem
        putchar(128);  //80
        putchar(2);    //02
        putchar(16);   //10
        
        delay_ms(1000);     //wywalenie bledu
        delay_ms(1000);
        
        putchar(90);  //5A
        putchar(165); //A5
        putchar(3);//03  //znak dzwiekowy ze jestem
        putchar(128);  //80
        putchar(2);    //02
        putchar(16);   //10
    
    }

delay_ms(1000);

while(cykl < 5)
{
    switch(cykl)
        {
        case 0:
        
            PORTA = 0xFF;   //STEP 0
            cykl = 1;
        
        break;
        
        case 1:
        
            if(sek1 > 1)
                {
                PORTD.3 = 1;  //DRIVE
                cykl = 2;
                }
        break;
        
        
        case 2:
    
               if(sprawdz_pin0(PORTJJ,0x79) == 0)
                  {
                  PORTD.3 = 0;
                  PORTA = 0x00;        //STEP 1 koniec
                  cykl = 3;
                  }
    
        break;
    
        case 3:
    
               if(sprawdz_pin3(PORTJJ,0x79) == 0)
                  {
                  sek1 = 0;
                  cykl = 4;
                  }
               
               if(sprawdz_pin5(PORTJJ,0x79) == 1)     //alarm
                   {
                   komunikat_na_panel("                                                ",adr1,adr2);
                   komunikat_na_panel("Przeciazenia LEFS_XY_1",adr1,adr2);
                   }
               
               
        break;
        
        
        case 4:
        
            if(sek1 > 50)
                cykl = 5;
        break;
        
        }
}

cykl = 0;
return 1;
}









void wypozycjonuj_napedy()
{
//if(aaa == 0)
//        {
//        aaa = wypozycjonuj_LEFS40_1200_1_i_300_1();
//        }              
if(bbb == 0)
        {
        bbb = wypozycjonuj_LEFS32_300_1(0);
        }
if(bbb == 1)
        {
        bbb = wypozycjonuj_LEFS32_300_1(1);
       }


//if(ccc == 0)
//        {
//        ccc = wypozycjonuj_LEFS40_1200_2_i_300_2();
//        }  
//if(ddd == 0)
//        {
//        ddd = wypozycjonuj_LEFS32_300_2(0);
//       }    
//if(ddd == 1)
//        {
//        ddd = wypozycjonuj_LEFS32_300_2(1);
//        }    

        
 



   /*
        
    if(ccc == 1 & bbb == 1)
        ccc = wypozycjonuj_NL3_upgrade(1);
    
    if(bbb == 1 & ccc == 2)
        bbb = wypozycjonuj_NL2_upgrade(1);
        
        
    if(aaa == 1 & bbb == 2 & ccc == 2)
        {
        start = 1;
        }
    
    */
    
//    if(aaa == 1 & bbb == 2 & ccc == 2 & ddd == 2)
//        start = 1;
    
    
}



void przerzucanie_dociskow()
{
   if(sprawdz_pin6(PORTLL,0x71) == 0 & sprawdz_pin7(PORTLL,0x71) == 0 & czekaj_az_puszcze == 0)
           {
           czekaj_az_puszcze = 1;
           PORTB.6 = 1;
           } 
       if(sprawdz_pin6(PORTLL,0x71) == 1 & sprawdz_pin7(PORTLL,0x71) == 1 & czekaj_az_puszcze == 1)  
           {
           czekaj_az_puszcze = 2;
           PORTB.6 = 0;
           }
           
       if(czekaj_az_puszcze == 2 & PORTE.6 == 1)
            {
            PORTE.6 = 0;    
            czekaj_az_puszcze = 0;
            delay_ms(100);
            }
       
       if(czekaj_az_puszcze == 2 & PORTE.6 == 0)
           {
            PORTE.6 = 1;    
            czekaj_az_puszcze = 0;
            delay_ms(100);
           }
       
}

void ostateczny_wybor_zacisku()
{
  if(sek11 > 40) //co 1s sekunde sprawdzam
        {
       sek11 = 0;
       if(odczytalem_zacisk < il_prob_odczytu &    
                                           (sprawdz_pin0(PORTHH,0x73) == 1 |
                                            sprawdz_pin1(PORTHH,0x73) == 1 |
                                            sprawdz_pin2(PORTHH,0x73) == 1 |
                                            sprawdz_pin3(PORTHH,0x73) == 1 |
                                            sprawdz_pin4(PORTHH,0x73) == 1 |
                                            sprawdz_pin5(PORTHH,0x73) == 1 |
                                            sprawdz_pin6(PORTHH,0x73) == 1 |
                                            sprawdz_pin7(PORTHH,0x73) == 1))
        {
        odczytalem_zacisk++;
        } 
        }

if(odczytalem_zacisk == il_prob_odczytu) 
        {
        //PORTB = 0xFF;
        odczyt_wybranego_zacisku();
        //sek10 = 0;
        sek11 = 0;    //nowe
        odczytalem_zacisk++;
        if(rzad == 1)
            wartosc_parametru_panelu(2,32,128);
        else
            wartosc_parametru_panelu(1,32,128);
        
        }                                     //& sek10 > 1                //3s po odczytaniu dopiero sprawdzam port
if((odczytalem_zacisk == il_prob_odczytu + 1))        //183
        {
        odczytalem_zacisk = 0;
        }
}



int sterownik_1_praca(int PORT, int a)
{
bit a,b,c,d,e,f;


PORT_STER3.byte = PORT;

a = PORT_STER3.bits.b0;
b = PORT_STER3.bits.b1;
c = PORT_STER3.bits.b2;
d = PORT_STER3.bits.b3;
e = PORT_STER3.bits.b4;
f = PORT_STER3.bits.b5;





//PORTA.0   IN0  STEROWNIK1   
//PORTA.1   IN1  STEROWNIK1
//PORTA.2   IN2  STEROWNIK1
//PORTA.3   IN3  STEROWNIK1
//PORTA.4   IN4  STEROWNIK1
//PORTA.5   IN5  STEROWNIK1
//PORTA.6   IN6  STEROWNIK1
//PORTA.7   IN7  STEROWNIK1
//PORTD.4   IN8 STEROWNIK1

//PORTD.2  SETUP   STEROWNIK1
//PORTD.3  DRIVE   STEROWNIK1

//sprawdz_pin0(PORTJJ,0x79)  BUSY   STEROWNIK1
//sprawdz_pin3(PORTJJ,0x79)  INP    STEROWNIK1 

switch(cykl_sterownik_1)
        {
        case 0:
        
            sek1 = 0;
            PORTA = PORT;      
            PORTD.4 = a;
            
            cykl_sterownik_1 = 1;
                 
        break;
        
        case 1:
        
            if(sek1 > 1)
                {
               
                PORTD.3 = 1;
                cykl_sterownik_1 = 2;
                }
        break;
        
        
        case 2:
    
               if(sprawdz_pin0(PORTJJ,0x79) == 0)     //busy
                  {
                 
                  PORTD.3 = 0;
                  PORTA = 0x00;
                  PORTD.4 = 0;
                  sek1 = 0;
                  cykl_sterownik_1 = 3;
                  }
    
        break;
    
        case 3:
    
               if(sprawdz_pin3(PORTJJ,0x79) == 0)
                  {
                
                  sek1 = 0;
                  cykl_sterownik_1 = 4;
                  }
               
               
        break;
        
        
        case 4:
        
            if(sprawdz_pin0(PORTJJ,0x79) == 1)
                {
               
                cykl_sterownik_1 = 5;
                }
        break;
        
        }

return cykl_sterownik_1;
}


int sterownik_2_praca(int PORT, int a)
{
//PORTC.0   IN0  STEROWNIK2   
//PORTC.1   IN1  STEROWNIK2
//PORTC.2   IN2  STEROWNIK2
//PORTC.3   IN3  STEROWNIK2
//PORTC.4   IN4  STEROWNIK2
//PORTC.5   IN5  STEROWNIK2
//PORTC.6   IN6  STEROWNIK2
//PORTC.7   IN7  STEROWNIK2
//PORTD.5   IN8 STEROWNIK2


//PORTD.5  SETUP   STEROWNIK2
//PORTD.6  DRIVE   STEROWNIK2

//sprawdz_pin0(PORTLL,0x71)  BUSY   STEROWNIK2
//sprawdz_pin3(PORTLL,0x71)  INP    STEROWNIK2


switch(cykl_sterownik_2)
        {
        case 0:
        
            sek3 = 0;
            PORTC = PORT;      
            PORTD.5 = a;
            
            cykl_sterownik_2 = 1;
            
                 
        break;
        
        case 1:
        
            if(sek3 > 1)
                {
                PORTD.6 = 1;
                cykl_sterownik_2 = 2;
                }
        break;
        
        
        case 2:
    
               if(sprawdz_pin0(PORTLL,0x71) == 0)     //busy
                  {
                  PORTD.6 = 0;
                  PORTC = 0x00;
                  PORTD.5 = 0;
                  sek3 = 0;
                  cykl_sterownik_2 = 3;
                  }
    
        break;
    
        case 3:
    
               if(sprawdz_pin3(PORTLL,0x71) == 0)
                  {
                  sek3 = 0;
                  cykl_sterownik_2 = 4;
                  }
               
               
        break;
        
        
        case 4:
        
            if(sprawdz_pin0(PORTLL,0x71) == 1)
                {
                cykl_sterownik_2 = 5;
                }
        break;
        
        }

return cykl_sterownik_2;
}





                     
int sterownik_3_praca(char f,char e,char d, char c, char b, char a)
{
//PORTF.0   IN0  STEROWNIK3   
//PORTF.1   IN1  STEROWNIK3
//PORTF.2   IN2  STEROWNIK3
//PORTF.3   IN3  STEROWNIK3
//PORTF.7   IN4 STEROWNIK 3 
//PORTB.7   IN5 STEROWNIK 3   



//PORTF.5   DRIVE  STEROWNIK3

//sprawdz_pin0(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK3
//sprawdz_pin3(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK3

switch(cykl_sterownik_3)
        {
        case 0:
        
            PORT_F.bits.b0 = a;      
            PORT_F.bits.b1 = b;
            PORT_F.bits.b2 = c;
            PORT_F.bits.b3 = d;
            PORT_F.bits.b7 = e;
            PORTF = PORT_F.byte;      
            PORTB.7 = f;
            
            sek2 = 0;
            cykl_sterownik_3 = 1;
                 
        break;
        
        case 1:
        
            if(sek2 > 1)
                {
                PORT_F.bits.b5 = 1;
                PORTF = PORT_F.byte;
                cykl_sterownik_3 = 2;    //drive
                }
        break;
        
        
        case 2:
    
               if(sprawdz_pin0(PORTKK,0x75) == 0)
                  {
                  PORT_F.bits.b5 = 0;       
                  PORTF = PORT_F.byte;
                  
                  PORT_F.bits.b0 = 0;      
                  PORT_F.bits.b1 = 0;
                  PORT_F.bits.b2 = 0;
                  PORT_F.bits.b3 = 0;
                  PORT_F.bits.b7 = 0;
                  PORTF = PORT_F.byte;  
                  PORTB.7 = 0;
                  
                  sek2 = 0;
                  cykl_sterownik_3 = 3;
                  }
    
        break;
    
        case 3:
    
               if(sprawdz_pin3(PORTKK,0x75) == 0)  //czy INP
                  {
                  sek2 = 0;
                  cykl_sterownik_3 = 4;
                  }
               
               
        break;
        
        
        case 4:
              
              if(sprawdz_pin0(PORTKK,0x75) == 1)  //czy BUSY
                {
                cykl_sterownik_3 = 5;
                
                 
                switch(cykl_sterownik_3_wykonalem)
                    {
                    case 0:
                            cykl_sterownik_3_wykonalem = 1;
                    break;
                    
                    case 1:
                            cykl_sterownik_3_wykonalem = 0;
                    break;
                    
                    } 
                 
                 
                }
        break;
        
        }

return cykl_sterownik_3;
}

//
//int sterownik_4_praca(char f,char e,char d, char c, char b, char a)
int sterownik_4_praca(int PORT)
{
bit a,b,c,d,e,f;


PORT_STER3.byte = PORT;

a = PORT_STER3.bits.b0;
b = PORT_STER3.bits.b1;
c = PORT_STER3.bits.b2;
d = PORT_STER3.bits.b3;
e = PORT_STER3.bits.b4;
f = PORT_STER3.bits.b5;


//PORTB.0   IN0  STEROWNIK4   
//PORTB.1   IN1  STEROWNIK4
//PORTB.2   IN2  STEROWNIK4
//PORTB.3   IN3  STEROWNIK4
//PORTE.4  IN4  STEROWNIK4 
//PORTE.5  IN5  STEROWNIK4


//PORTB.4   SETUP  STEROWNIK4
//PORTB.5   DRIVE  STEROWNIK4

//sprawdz_pin4(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK4
//sprawdz_pin7(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK4 



switch(cykl_sterownik_4)
        {
        case 0:
        
            PORTB.0 = a;      
            PORTB.1 = b;
            PORTB.2 = c;
            PORTB.3 = d;
            PORTE.4 = e;
            PORTE.5 = f;
            
            sek4 = 0;
            cykl_sterownik_4 = 1;
                 
        break;
        
        case 1:
        
            if(sek4 > 1)
                {
                PORTB.5 = 1;
                cykl_sterownik_4 = 2;    //drive
                }
        break;
        
        
        case 2:
    
               if(sprawdz_pin4(PORTKK,0x75) == 0)
                  {
                  PORTB.5 = 0;  //drive
                  
                  PORTB.0 = a;      
                  PORTB.1 = b;
                  PORTB.2 = c;
                  PORTB.3 = d;
                  PORTE.4 = e;
                  PORTE.5 = f;
                  
                  sek4 = 0;
                  cykl_sterownik_4 = 3;
                  }
    
        break;
    
        case 3:
    
               if(sprawdz_pin7(PORTKK,0x75) == 0)  //czy INP
                  {
                  sek4 = 0;
                  cykl_sterownik_4 = 4;
                  }
               
               
        break;
        
        
        case 4:
              
              if(sprawdz_pin4(PORTKK,0x75) == 1)  //czy BUSY
                {
                cykl_sterownik_4 = 5;
                }
        break;
        
        }

return cykl_sterownik_4;
}





void main(void)
{

// Declare your local variables here
/*
// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTB=0x00;
DDRB=0xFF;

// Port C initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTC=0x00;
DDRC=0xFF;

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
*/


// Input/Output Ports initialization
// Port A initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTA=0x00;
DDRA=0xFF;

// Port B initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTB=0x00;
DDRB=0xFF;

// Port C initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTC=0x00;
DDRC=0xFF;

// Port D initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTD=0x00;
DDRD=0xFF;

// Port E initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTE=0x00;
DDRE=0xFF;

// Port F initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTF=0x00;
DDRF=0xFF;

// Port G initialization
// Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State4=0 State3=0 State2=0 State1=0 State0=0 
PORTG=0x00;
DDRG=0x1F;





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
UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
UBRR0H=0x00;
UBRR0L=0x08;

// USART1 initialization
// USART1 disabled
UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (0<<RXEN1) | (0<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);

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

//ciekawe, tej linijki brakowalo w medalach ,wyczailem w borgu
// I2C Bus initialization
i2c_init();

// Global enable interrupts
#asm("sei")


//delay_ms(8000); //bo panel sie inicjalizuje
//delay_ms(2000); //bo panel sie inicjalizuje
delay_ms(2000); //bo panel sie inicjalizuje
delay_ms(2000); //bo panel sie inicjalizuje
delay_ms(2000); //bo panel sie inicjalizuje
delay_ms(2000); //bo panel sie inicjalizuje

//delay_ms(2000); //bo panel sie inicjalizuje
//delay_ms(2000); //bo panel sie inicjalizuje
//delay_ms(2000); //bo panel sie inicjalizuje
//delay_ms(2000); //bo panel sie inicjalizuje

//jak patrze na maszyne to ten po lewej to 1

putchar(90);  //5A
putchar(165); //A5
putchar(3);//03  //znak dzwiekowy ze jestem
putchar(128);  //80
putchar(2);    //02
putchar(16);   //10

il_prob_odczytu = 1;    //100
start = 0;
szczotka_druciana_ilosc_cykli = 4;
krazek_scierny_cykl_po_okregu_ilosc = 4;
krazek_scierny_ilosc_cykli = 4;
rzad_obrabiany = 1;
jestem_w_trakcie_czyszczenia_calosci = 0;
wykonalem_rzedow = 0;
cykl_ilosc_zaciskow = 0;
guzik1_przelaczania_zaciskow = 1;
guzik2_przelaczania_zaciskow = 1;
PORTE.6 = 1;  //aby byl dostep do zaciskow rzad 1
zmienna_przelaczanie_zaciskow = 1;
czas_przedmuchu = 183;


adr1 = 80;  //rzad 1
adr2 = 0;   //
adr3 = 64;  //rzad 2
adr4 = 0;



//zapal lampki
//PORTB.6 = 1;
//PORTD.7 = 1;
//PORT_F.bits.b6 = 1;      
//PORTF = PORT_F.byte;  

//PORT_F.bits.b4 = 0;  //przedmuch zaciskow    
//PORTF = PORT_F.byte;  
//PORTB.4 = 1;  //przedmuch osi
//PORTE.2 = 1;  //szlifierka 1
//PORTE.3 = 1;  //szlifierka 2
//PORTE.6 = 0;  //zacisniety rzad 1
//PORTE.6 = 1;  //zacisniety rzad 2
//PORTE.7 = 0;    //zacisnij zaciski

//zalozenie: nie mozna czytac kodow kreskowych jak juz dalem start i idzie, dopoki nie skonczy


wypozycjonuj_napedy_minimalistyczna();
sprawdz_cisnienie();

while (1)
      {         
      ostateczny_wybor_zacisku();
      start = odczytaj_parametr(0,64);
      il_zaciskow_rzad_1 = odczytaj_parametr(0,128); 
      il_zaciskow_rzad_2 = odczytaj_parametr(0,48);
      przerzucanie_dociskow();
      wybor_linijek_sterownikow();
      
      
      while((start == 1 & il_zaciskow_rzad_1 > 0) | jestem_w_trakcie_czyszczenia_calosci == 1)
            {
            switch (cykl_glowny)
            {
            case 0:
                           
                    
                    PORTB.6 = 1;   ////zielona lampka 
                    if(jestem_w_trakcie_czyszczenia_calosci == 0)
                        {
                        wartosc_parametru_panelu(0,0,16);  //wykonano zaciskow rzad1
                        wartosc_parametru_panelu(0,0,96);  //wykonano zaciskow rzad2
                        }
                    
                    jestem_w_trakcie_czyszczenia_calosci = 1;
                    
                    if(rzad_obrabiany == 1)
                    {
                    PORTE.6 = 0;    //przelacz rzad zaciskow - rzad 1
                    if(cykl_sterownik_1 < 5)
                        cykl_sterownik_1 = sterownik_1_praca(0x09,0);
                    if(cykl_sterownik_2 < 5)                                //ster 1 do 0
                        cykl_sterownik_2 = sterownik_2_praca(0x00,0);       //ster 2 pod pin pozy rzad 1
                    }
                    
                    if(rzad_obrabiany == 2)
                    {
                    PORTE.6 = 1;    //przelacz rzad zaciskow - rzad 2
                    if(cykl_sterownik_1 < 5)
                        cykl_sterownik_1 = sterownik_1_praca(0x08,0);
                    if(cykl_sterownik_2 < 5)                                //ster 1 do 0
                        cykl_sterownik_2 = sterownik_2_praca(0x01,0);       //ster 2 pod pin pozy rzad 2
                    }
                    
                    
                    if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
                        {
                        
                        cykl_sterownik_1 = 0;
                        cykl_sterownik_2 = 0;
                        cykl_sterownik_3 = 0;
                        cykl_sterownik_4 = 0;
                        cykl_ilosc_zaciskow = 0;
                        koniec_rzedu_10 = 0;
                        start_kontynuacja = odczytaj_parametr(0,64);
                        if(start_kontynuacja == 1)
                            cykl_glowny = 1;
                        }
            
            break;
            
            
            
            case 1:
            
                     
                     if(cykl_sterownik_2 < 5 & rzad_obrabiany == 1)
                        //cykl_sterownik_2 = sterownik_2_praca(0x5A,0);         //ster 1 nic
                          cykl_sterownik_2 = sterownik_2_praca(a[0],a[1]);        //ster 2 pod zacisk
                                                                              //ster 4 na pozycje miedzy rzedzami
                     
                     if(cykl_sterownik_2 < 5 & rzad_obrabiany == 2)
                        //cykl_sterownik_2 = sterownik_2_praca(0x5B,0);
                          cykl_sterownik_2 = sterownik_2_praca(a[2],a[3]);
                     
                     if(cykl_sterownik_4 < 5 & cykl_sterownik_2 == 5)
                       // cykl_sterownik_4 = sterownik_4_praca(0,0,0,0,0,1);
                        cykl_sterownik_4 = sterownik_4_praca(0x01);
                     
                      if(cykl_sterownik_2 == 5 & cykl_sterownik_4 == 5)
                        {
                        cykl_sterownik_1 = 0;
                        cykl_sterownik_2 = 0;
                        cykl_sterownik_4 = 0;
                        szczotka_druc_cykl = 0;
                        
                        
                        start_kontynuacja = odczytaj_parametr(0,64);
                        if(start_kontynuacja == 1)
                            cykl_glowny = 2;
                        }   
                        
                         
            break;
            
            
            case 2:
            
                    if(cykl_sterownik_4 < 5)
                        cykl_sterownik_4 = sterownik_4_praca(1,0,0,0,1,0);  //ABS
                    if(cykl_sterownik_4 == 5)
                        {
                        PORTE.2 = 1;  //wlacz szlifierke
                        cykl_sterownik_4 = 0;
                        start_kontynuacja = odczytaj_parametr(0,64);
                        if(start_kontynuacja == 1)
                            cykl_glowny = 3;
                        }
                     
            break;
            
            
            case 3:
                    if(cykl_sterownik_4 < 5)
                       cykl_sterownik_4 = sterownik_4_praca(0,1,0,0,0,1); //INV
                       
                    if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli)
                        {
                        szczotka_druc_cykl++;
                        cykl_sterownik_4 = 0;
                        
                        if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)
                            {
                            start_kontynuacja = odczytaj_parametr(0,64);
                            if(start_kontynuacja == 1)
                                  cykl_glowny = 4;
                            }
                        else
                            {
                            start_kontynuacja = odczytaj_parametr(0,64);
                            if(start_kontynuacja == 1)
                                cykl_glowny = 2;
                            
                            
                            }
                        }
                    
                       
                       
            break;
            
            case 4:
            
                     if(cykl_sterownik_4 < 5)
                        cykl_sterownik_4 = sterownik_4_praca(0,0,0,0,0,1);  //do pozycji bazowej
                        
                     if(cykl_sterownik_4 == 5)
                        {
                        PORTE.2 = 0;  //wylacz szlifierke
                        cykl_sterownik_4 = 0;
                        start_kontynuacja = odczytaj_parametr(0,64);
                        if(start_kontynuacja == 1)
                            {
                            ruch_zlozony = 0;
                            cykl_glowny = 5;
                            }
                        }            
            
            break;
            
            case 5:
            
            
                    if(cykl_sterownik_1 < 5 & ruch_zlozony == 0 & rzad_obrabiany == 1)
                        cykl_sterownik_1 = sterownik_1_praca(0x00,0);
                    if(cykl_sterownik_1 < 5 & ruch_zlozony == 0 & rzad_obrabiany == 2)
                        cykl_sterownik_1 = sterownik_1_praca(0x01,0);
                    
                    
                    
                    if(cykl_sterownik_1 == 5 & ruch_zlozony == 0)
                        {
                        cykl_sterownik_1 = 0;
                        ruch_zlozony = 1;
                        }
                    
                    if(cykl_sterownik_1 < 5 & ruch_zlozony == 1 & rzad_obrabiany == 1)
                        cykl_sterownik_1 = sterownik_1_praca(0x5A,0);
                    if(cykl_sterownik_1 < 5 & ruch_zlozony == 1 & rzad_obrabiany == 2)
                        cykl_sterownik_1 = sterownik_1_praca(0x5B,0);
                    
                    
                    
                    if(cykl_sterownik_1 < 5 & ruch_zlozony == 2)
                        cykl_sterownik_1 = sterownik_1_praca(0x03,0);
                    
                    if(cykl_sterownik_2 < 5 & koniec_rzedu_10 == 0)                                //ster 1 do pierwszego dolka
                        cykl_sterownik_2 = sterownik_2_praca(0x03,0);       //ster 2 pod nastpeny dolek
                    
                    
                    if(cykl_sterownik_2 < 5 & koniec_rzedu_10 == 1 & rzad_obrabiany == 1)                                
                        cykl_sterownik_2 = sterownik_2_praca(0x08,0);      //ster 2 do samego tylu
                     if(cykl_sterownik_2 < 5 & koniec_rzedu_10 == 1 & rzad_obrabiany == 2)                                
                        cykl_sterownik_2 = sterownik_2_praca(0x09,0);      //ster 2 do samego tylu
                    
                    if((cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5 & ruch_zlozony == 1) | (cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5) & ruch_zlozony == 2)
                        {
                        cykl_sterownik_1 = 0;
                        cykl_sterownik_2 = 0;
                        cykl_sterownik_4 = 0;
                        cykl_sterownik_3 = 0;
                        sek12 = 0;    //do przedmuchu
                        start_kontynuacja = odczytaj_parametr(0,64);
                        if(start_kontynuacja == 1)
                            {
                            if(cykl_ilosc_zaciskow > 0)
                                {
                                PORT_F.bits.b4 = 1;  //przedmuch zaciskow    
                                PORTF = PORT_F.byte;
                                }
                            cykl_glowny = 6;
                            }
                        }
            
            break;
            
           
      
           case 6:
                    
                    
                    if(sek12 > czas_przedmuchu)
                        {
                        PORT_F.bits.b4 = 0;  //przedmuch zaciskow    
                        PORTF = PORT_F.byte;  
                        }
                    
                    if(cykl_sterownik_3 < 5)
                        cykl_sterownik_3 = sterownik_3_praca(1,0,0,0,0,1);  //ABS          //krazek scierny do gory
                    
                    if(koniec_rzedu_10 == 1)         
                        cykl_sterownik_4 = 5;
                        
                    if(cykl_sterownik_4 < 5)
                        cykl_sterownik_4 = sterownik_4_praca(1,0,0,0,1,0);  //ABS          //druciak do gory
                    
                    if(cykl_sterownik_4 == 5 & cykl_sterownik_3 == 5)
                        {
                        if((cykl_ilosc_zaciskow != il_zaciskow_rzad_1 - 1 & rzad_obrabiany == 1) | (cykl_ilosc_zaciskow != il_zaciskow_rzad_2 - 1 & rzad_obrabiany == 2))
                            PORTE.2 = 1;  //wlacz szlifierke
                        PORTE.3 = 1;  //szlifierka 2 (krazek scierny)
                        cykl_sterownik_3 = 0;
                        cykl_sterownik_4 = 0;
                        start_kontynuacja = odczytaj_parametr(0,64);
                        if(start_kontynuacja == 1)
                            cykl_glowny = 7;
                        }
           
           break;
      
      
           case 7:
                                                                                              //mini ruch do przygotowania do okregu
                    if(cykl_sterownik_1 < 5)
                        cykl_sterownik_1 = sterownik_1_praca(0x96,1);
                      
                    if(cykl_sterownik_1 == 5)
                        {
                        cykl_sterownik_1 = 0;
                        cykl_glowny = 8;
                        szczotka_druc_cykl = 0;
                        krazek_scierny_cykl_po_okregu = 0;
                        wykonalem_komplet_okregow = 0;
                        abs_ster3 = 0;
                        abs_ster4 = 0;
                        }
                    
                        
           
           break;
      
      
            case 8:
            
                    
                
            
                    if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 0)
                        cykl_sterownik_1 = sterownik_1_praca(0x97,1);
                      
                    if(cykl_sterownik_1 == 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 0)
                        {
                        cykl_sterownik_1 = 0;
                        krazek_scierny_cykl_po_okregu++;
                        }
                        
                    if(krazek_scierny_cykl_po_okregu == krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 0)
                        {
                        cykl_sterownik_1 = 0;
                        wykonalem_komplet_okregow = 1;
                        }
                    
                    if(koniec_rzedu_10 == 1)         
                        cykl_sterownik_4 = 5;
                    
                    if(cykl_sterownik_4 < 5 & abs_ster4 == 0)
                       cykl_sterownik_4 = sterownik_4_praca(0,1,0,0,0,1); //INV               //szczotka druc
                       
                    if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli)
                        {
                        if(koniec_rzedu_10 == 0)
                            cykl_sterownik_4 = 0;
                        if(abs_ster4 == 0)
                            {
                            szczotka_druc_cykl++;
                            abs_ster4 = 1;
                            }
                        else
                            abs_ster4 = 0;
                        }
                     
                    if(cykl_sterownik_3 < 5 & abs_ster3 == 0)
                       cykl_sterownik_3 = sterownik_3_praca(0,1,0,0,1,0); //INV                   //krazek scierny
                       
                    
                    if(cykl_sterownik_3 == 5 & krazek_scierny_cykl < krazek_scierny_ilosc_cykli)
                        {
                        
                         cykl_sterownik_3 = 0;
                        if(abs_ster3 == 0)
                            {
                            krazek_scierny_cykl++;
                            abs_ster3 = 1;
                            }
                        else
                            abs_ster3 = 0;
                        }
                    
                    if(cykl_sterownik_3 < 5 & abs_ster3 == 1)
                        cykl_sterownik_3 = sterownik_3_praca(1,0,0,0,0,1);  //ABS          //krazek scierny do gory
                    
                    if(cykl_sterownik_4 < 5 & abs_ster4 == 1)
                        cykl_sterownik_4 = sterownik_4_praca(1,0,0,0,1,0);  //ABS          //druciak do gory
                    
                    
                                                                                           //mini ruch powrotny do okregu, zeby nie szorowal
                    if(cykl_sterownik_1 < 5 & wykonalem_komplet_okregow == 1)
                        cykl_sterownik_1 = sterownik_1_praca(0x98,1);
                   
                       
                    if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 1 &
                       szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
                       krazek_scierny_cykl == krazek_scierny_ilosc_cykli)                                
                        {
                        cykl_sterownik_1 = 0;
                        cykl_sterownik_2 = 0;
                        cykl_sterownik_3 = 0;
                        cykl_sterownik_4 = 0;
                        cykl_glowny = 8;
                        szczotka_druc_cykl = 0;
                        krazek_scierny_cykl = 0;
                        krazek_scierny_cykl_po_okregu = 0;
                        PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz    
                        PORTF = PORT_F.byte;
                        cykl_glowny = 9;
                        } 
                    
                                                                                                //ster 1 - ruch po okregu
                                                                                                //ster 2 - nic
                                                                                                //ster 3 - krazek - gora dol
                                                                                                //ster 4 - druciak - gora dol 
            
            break;       
                         
            
            case 9:
            
                         
                         if(rzad_obrabiany == 1)
                         {
                         if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow != il_zaciskow_rzad_1 - 1)
                            cykl_sterownik_3 = sterownik_3_praca(0,0,0,0,0,1);  //do pozycji bazowej
                            
                          //if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow != il_zaciskow_rzad_1 - 1)
                          //  cykl_sterownik_4 = sterownik_4_praca(0,0,0,0,0,1);  //do pozycji bazowej
                          
                          if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow < il_zaciskow_rzad_1 - 2)
                            cykl_sterownik_4 = sterownik_4_praca(0,0,0,0,0,1);  //do pozycji bazowej
                          
                          
                         if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow == il_zaciskow_rzad_1 - 1)
                            cykl_sterownik_3 = sterownik_3_praca(0,0,0,0,0,0);  //na sam dol, jedziemy miedzy rzedami
                            
                          //if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow == il_zaciskow_rzad_1 - 1)
                         //   cykl_sterownik_4 = sterownik_4_praca(0,0,0,0,0,0);  //na sam dol, jedziemy miedzy rzedami
                         
                         if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow >= il_zaciskow_rzad_1 - 2)
                            cykl_sterownik_4 = sterownik_4_praca(0,0,0,0,0,0);  //na sam dol, jedziemy miedzy rzedami
                         
                          }
                          
                         
                         if(rzad_obrabiany == 2)
                         {
                         if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow != il_zaciskow_rzad_2 - 1)
                            cykl_sterownik_3 = sterownik_3_praca(0,0,0,0,0,1);  //do pozycji bazowej
                            
                         // if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow != il_zaciskow_rzad_2 - 1)
                         //   cykl_sterownik_4 = sterownik_4_praca(0,0,0,0,0,1);  //do pozycji bazowej
                         
                          if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow < il_zaciskow_rzad_2 - 2)
                            cykl_sterownik_4 = sterownik_4_praca(0,0,0,0,0,1);  //do pozycji bazowej  
                          
                         if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow == il_zaciskow_rzad_2 - 1)
                            cykl_sterownik_3 = sterownik_3_praca(0,0,0,0,0,0);  //na sam dol, jedziemy miedzy rzedami
                            
                         // if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow == il_zaciskow_rzad_2 - 1)
                         //   cykl_sterownik_4 = sterownik_4_praca(0,0,0,0,0,0);  //na sam dol, jedziemy miedzy rzedami
                         
                          if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow >= il_zaciskow_rzad_2 - 2)
                            cykl_sterownik_4 = sterownik_4_praca(0,0,0,0,0,0);  //na sam dol, jedziemy miedzy rzedami
                         
                          }
                         
                             
                          if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
                            {
                            PORTE.2 = 0;  //wylacz szlifierke
                            PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
                            cykl_sterownik_4 = 0;
                            cykl_sterownik_3 = 0;
                            cykl_ilosc_zaciskow++;
                            ruch_zlozony = 2;                       //il_zaciskow_rzad_1 
                            cykl_glowny = 10;
                            }
                          
                          
            break;
            
            
            
            case 10:
            
                                               //wywali ten warunek jak zadziala
                     if(rzad_obrabiany == 1 & cykl_glowny != 0)
                            {
                            wartosc_parametru_panelu(cykl_ilosc_zaciskow,0,16);  //wykonano zaciskow rzad1
                            if(cykl_ilosc_zaciskow <  il_zaciskow_rzad_1 - 1)
                                {
                                cykl_glowny = 5;
                                koniec_rzedu_10 = 0;
                                }
                                    
                            if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 - 1)
                                {
                                cykl_glowny = 5;
                                koniec_rzedu_10 = 1;
                                }
                             
                            if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 & il_zaciskow_rzad_1 == 10)       
                                {
                                cykl_glowny = 11;
                                }   
                              
                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 & il_zaciskow_rzad_1 != 10)  /////zmieniam + 1 20.02
                                {
                                cykl_glowny = 14;
                                }
                            }
                            
                             
                            if(rzad_obrabiany == 2 & cykl_glowny != 0)
                            {
                            wartosc_parametru_panelu(cykl_ilosc_zaciskow,0,96);  //wykonano zaciskow rzad1
                            if(cykl_ilosc_zaciskow <  il_zaciskow_rzad_2 - 1)
                                {
                                cykl_glowny = 5;
                                koniec_rzedu_10 = 0;
                                }
                                    
                            if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 - 1)
                                {
                                cykl_glowny = 5;
                                koniec_rzedu_10 = 1;
                                }
                             
                            if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 & il_zaciskow_rzad_2 == 10)       
                                {
                                cykl_glowny = 12;
                                }    
                            
                         
                             if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 & il_zaciskow_rzad_2 != 10)   ///////////////////zmieniam + 1 20.02
                                {
                                cykl_glowny = 14;
                                }
                            }
            
            
            
            break;
            
            
            
            case 11:
                             
                             //ster 1 ucieka od szafy
                             if(cykl_sterownik_1 < 5) 
                                    cykl_sterownik_1 = sterownik_1_praca(0x07,0);     //uciekamy do tylu
                             
                             if(cykl_sterownik_2 < 5) 
                                    cykl_sterownik_2 = sterownik_2_praca(0x90,1);     //pod dolek ostatni 10 do przedmuchu rzad 1
                             
                             if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
                                    {
                                    PORT_F.bits.b4 = 1;  //przedmuch zaciskow    
                                    PORTF = PORT_F.byte;
                                    cykl_sterownik_1 = 0;
                                    cykl_sterownik_2 = 0;
                                    cykl_glowny = 13;
                                    }  
            break;
            
            
            case 12:
                            
                               //ster 1 ucieka od szafy
                             if(cykl_sterownik_1 < 5) 
                                    cykl_sterownik_1 = sterownik_1_praca(0x07,0);     //uciekamy do tylu
                                    
                            if(cykl_sterownik_2 < 5) 
                                    cykl_sterownik_2 = sterownik_2_praca(0x91,1);     //pod dolek ostatni 10 do przedmuchu rzad 2
                            
                             if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
                                    {
                                    PORT_F.bits.b4 = 1;  //przedmuch zaciskow    
                                    PORTF = PORT_F.byte;
                                    cykl_sterownik_1 = 0;
                                    cykl_sterownik_2 = 0;
                                    cykl_glowny = 13;
                                    }  
            
            
            break;
            
            
            
            case 13:        
                           
                             
                             if(cykl_sterownik_2 < 5) 
                                    cykl_sterownik_2 = sterownik_2_praca(0x92,1);     //okrag
                             if(cykl_sterownik_2 == 5)
                                    {
                                    PORT_F.bits.b4 = 0;  //przedmuch zaciskow - wylaczenie   
                                    PORTF = PORT_F.byte;
                                    cykl_sterownik_2 = 0;
                                    cykl_glowny = 16;
                                    }  
            
            break;
            
            
            
            case 14:
            
                  
                    if(cykl_sterownik_1 < 5)    
                        cykl_sterownik_1 = sterownik_1_praca(0x03,0);     //pod nastepny dolek zeby przedmuchac
                    if(cykl_sterownik_1 == 5)
                        {
                        cykl_sterownik_1 = 0;
                        sek12 = 0;
                        cykl_glowny = 15;
                        }
            
            break;
            
            
       
            case 15:
            
                    //przedmuch
                    PORT_F.bits.b4 = 1;  //przedmuch zaciskow    
                    PORTF = PORT_F.byte;
                    if(sek12 > czas_przedmuchu)
                        {
                        PORT_F.bits.b4 = 0;  //przedmuch zaciskow    
                        PORTF = PORT_F.byte;  
                        cykl_glowny = 16;
                        }
            break;
            
            
            case 16:
            
                     if(cykl_ilosc_zaciskow == il_zaciskow_rzad_1 & wykonalem_rzedow == 0)  /////zmieniam + 1 20.02
                                {
                                cykl_ilosc_zaciskow = 0;
                                
                                if(il_zaciskow_rzad_2 > 0)
                                    {
                                    rzad_obrabiany = 2;
                                    cykl_glowny = 0;
                                    }
                                else
                                    cykl_glowny = 17;
                                    
                                wykonalem_rzedow = 1;
                                }
                       
                       if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 & il_zaciskow_rzad_2 > 0 & wykonalem_rzedow == 1)   ///////////////////zmieniam + 1 20.02
                                {
                                cykl_ilosc_zaciskow = 0;
                                cykl_glowny = 17;
                                rzad_obrabiany = 1;
                                wykonalem_rzedow = 2;
                                }
            
            
            
                        
                        if(il_zaciskow_rzad_1 > 0 & il_zaciskow_rzad_2 > 0 & wykonalem_rzedow == 2)
                                  {
                                  rzad_obrabiany = 1;
                                  wykonalem_rzedow = 0;
                                  PORTE.6 = 0;    //przelacz rzad zaciskow - rzad 1
                                  PORTB.6 = 0;   ////zielona lampka
                                  wartosc_parametru_panelu(0,0,64);
                                  }
                          
                            if(il_zaciskow_rzad_1 > 0 & il_zaciskow_rzad_2 == 0 & wykonalem_rzedow == 1)
                                  {
                                  rzad_obrabiany = 1;
                                  wykonalem_rzedow = 0;
                                  PORTE.6 = 1;    //przelacz rzad zaciskow - rzad 2
                                  PORTB.6 = 0;   ////zielona lampka
                                  wartosc_parametru_panelu(0,0,64);
                                  }
            
            
            
            break;
            
            
            case 17:
            
                                 
                                 if(cykl_sterownik_1 < 5)
                                    cykl_sterownik_1 = sterownik_1_praca(0x09,0);
                                 if(cykl_sterownik_2 < 5)                                //ster 1 do 0
                                    cykl_sterownik_2 = sterownik_2_praca(0x00,0);       //ster 2 pod pin pozy rzad 1
                                    
                                    if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
                                        {
                                        cykl_sterownik_1 = 0;
                                        cykl_sterownik_2 = 0;
                                        jestem_w_trakcie_czyszczenia_calosci = 0;
                                        start = 0;
                                        }
                                       
            
            
            
            break;
            
            
            }//switch

         
  }//while
}//while glowny

}//koniec



//odrzuty
 /*
      putchar(90);
      putchar(165);
      putchar(10);       //ilosc liter 8 + 3, tu moze byc faza bo jade przez putchar a nie printf, moze byc wiecej znakow
      putchar(130);  //82
      putchar(0);    //0
      putchar(80);  //adres 90 - 144   , nowy adres to 50 czyli 80
      putchar('8');
      putchar('6');
      putchar('-');
      putchar('0');
      putchar('1');
      putchar('9');
      putchar('3');
      */
      
      
      
      
//odrzuty
/*
  while(cykl_sterownik_2 != 5)
        {
        if(cykl_sterownik_2 < 5) 
                cykl_sterownik_2 = sterownik_2_praca(0x00,0);
           
        }
      
        if(cykl_sterownik_2 == 5)
              cykl_sterownik_2 = 0;   
        
        while(cykl_sterownik_2 != 5)
        {
        xxx = 1;
        PORTB.6 = 0;  //zielona lampka
        if(cykl_sterownik_2 < 5) 
                cykl_sterownik_2 = sterownik_2_praca(0x5A,0);
           
        }
        
        
        while(1)
            {
            }
            
*/

 /*
        if(cykl_sterownik_3 < 5 & cykl_sterownik_3_wykonalem == 0) 
                cykl_sterownik_3 = sterownik_3_praca(0,0,1,0,1,0);
        if(cykl_sterownik_3 == 5)
              cykl_sterownik_3 = 0;   
        if(cykl_sterownik_3 < 5 & cykl_sterownik_3_wykonalem == 1) 
                cykl_sterownik_3 = sterownik_3_praca(0,0,1,0,1,1);
        
        */
        
        
 /*
             if(cykl_sterownik_1 != 5) 
                cykl_sterownik_1 = sterownik_1_praca(0x00);
             if(cykl_sterownik_3 != 5) 
                cykl_sterownik_3 = sterownik_3_praca(0,0,0,0);
             */
             

//interrupt [TIM2_OVF] void timer2_ovf_isr(void)
//{
  
/*
if(odczytalem_zacisk < il_prob_odczytu & (PINA.0 == 1 | PINA.1 == 1 | PINA.2 == 1 | PINA.3 == 1 | PINA.4 == 1 | PINA.5 == 1 | PINA.6 == 1 | PINA.7 == 1))
    {
    //PORT_CZYTNIK.byte = PORTHH.byte;

    PORT_CZYTNIK.bits.b0 = PINA.0;
    PORT_CZYTNIK.bits.b1 = PINA.1;
    PORT_CZYTNIK.bits.b2 = PINA.2;
    PORT_CZYTNIK.bits.b3 = PINA.3;
    PORT_CZYTNIK.bits.b4 = PINA.4;
    PORT_CZYTNIK.bits.b5 = PINA.5;
    PORT_CZYTNIK.bits.b6 = PINA.6;
    PORT_CZYTNIK.bits.b7 = PINA.7;
    
    odczytalem_zacisk++;
    }


*/

/*
if(odczytalem_zacisk < il_prob_odczytu &    
                                           (sprawdz_pin0(PORTHH,0x73) == 1 |
                                            sprawdz_pin1(PORTHH,0x73) == 1 |
                                            sprawdz_pin2(PORTHH,0x73) == 1 |
                                            sprawdz_pin3(PORTHH,0x73) == 1 |
                                            sprawdz_pin4(PORTHH,0x73) == 1 |
                                            sprawdz_pin5(PORTHH,0x73) == 1 |
                                            sprawdz_pin6(PORTHH,0x73) == 1 |
                                            sprawdz_pin7(PORTHH,0x73) == 1))
        {
        //PORTB = 0xFF;
        odczytalem_zacisk++;
        } 

*/

//}


/*


                         if(rzad_obrabiany == 1)
                         {
                         if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow != 2)
                            cykl_sterownik_3 = sterownik_3_praca(0,0,0,0,0,1);  //do pozycji bazowej
                            
                          if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow != 2)
                            cykl_sterownik_4 = sterownik_4_praca(0,0,0,0,0,1);  //do pozycji bazowej
                          
                          
                         if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow == 2)
                            cykl_sterownik_3 = sterownik_3_praca(0,0,0,0,0,0);  //na sam dol, jedziemy miedzy rzedami
                            
                          if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow == 2)
                            cykl_sterownik_4 = sterownik_4_praca(0,0,0,0,0,0);  //na sam dol, jedziemy miedzy rzedami
                          }
                         

*/