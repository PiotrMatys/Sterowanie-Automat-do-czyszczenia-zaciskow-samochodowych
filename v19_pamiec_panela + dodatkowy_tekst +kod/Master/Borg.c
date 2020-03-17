/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
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


//#pragma warn-
           
//eeprom int czas_pracy_krazka_sciernego_h_34, czas_pracy_krazka_sciernego_h_36, czas_pracy_krazka_sciernego_h_38;
//eeprom int czas_pracy_krazka_sciernego_h_41, czas_pracy_krazka_sciernego_h_43;
//eeprom int czas_pracy_szczotki_drucianej_h;


//eeprom int tryb_pracy_szczotki_drucianej;

//#pragma warn+


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
   }bits;
   unsigned char byte;
}DD;





BB PORT_F;
BB PORTHH,PORT_CZYTNIK;
BB PORTJJ,PORTKK,PORTLL,PORTMM;
CC PORT_STER3,PORT_STER4;
DD PORT_STER1,PORT_STER2;

////////////to idzie do stalej pamieci
int szczotka_druciana_ilosc_cykli;
int krazek_scierny_ilosc_cykli;
int krazek_scierny_cykl_po_okregu_ilosc;
int tryb_pracy_szczotki_drucianej;
int czas_pracy_szczotki_drucianej_stala;
int czas_pracy_krazka_sciernego_stala;
int czas_pracy_krazka_sciernego_h_34, czas_pracy_krazka_sciernego_h_36, czas_pracy_krazka_sciernego_h_38;
int czas_pracy_krazka_sciernego_h_41, czas_pracy_krazka_sciernego_h_43;
int czas_pracy_szczotki_drucianej_h_17;
int czas_pracy_szczotki_drucianej_h_15;

//////////////////////////////////////////////




int xxx;
int nr_zacisku,odczytalem_zacisk,il_prob_odczytu;
int macierz_zaciskow[3];
long int sek1,sek2,sek3,sek4,sek5,sek6,sek7,sek8,sek9,sek10,sek11,sek12,sek13,sek20,sek80;
int czas_zatrzymania_na_dole;
//int rzad;
int start;
int cykl;
int aaa,bbb,ccc,ddd;
int il_zaciskow_rzad_1,il_zaciskow_rzad_2;
int cykl_sterownik_1,cykl_sterownik_3,cykl_sterownik_2,cykl_sterownik_4;
int adr1,adr2,adr3,adr4;
int cykl_sterownik_3_wykonalem;
int szczotka_druc_cykl;
int cykl_glowny;
int start_kontynuacja;
int ruch_zlozony;
int krazek_scierny_cykl_po_okregu;
int krazek_scierny_cykl;
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
//int wymieniono_szczotke_druciana,wymieniono_krazek_scierny;
int predkosc_pion_szczotka, predkosc_pion_krazek;
int wejscie_krazka_sciernego_w_pow_boczna_cylindra;
int predkosc_ruchow_po_okregu_krazek_scierny;
int test_geometryczny_rzad_1, test_geometryczny_rzad_2;
//int czas_pracy_krazka_sciernego,czas_pracy_szczotki_drucianej;
int powrot_przedwczesny_druciak;
int powrot_przedwczesny_krazek_scierny;
int czas_druciaka_na_gorze;
int srednica_krazka_sciernego;
int manualny_wybor_zacisku;
int ruch_haos;
int byla_wloczona_szlifierka_2,byla_wloczona_szlifierka_1;
int byl_wloczony_przedmuch,zastopowany_czas_przedmuchu;
int cisnienie_sprawdzone;
int odczytalem_w_trakcie_czyszczenia_drugiego_rzedu;
int zaaktualizuj_ilosc_rzad2;
int srednica_wew_korpusu;
int srednica_wew_korpusu_cyklowa;
int wykonano_powrot_przedwczesny_krazek_scierny;
int wykonano_powrot_przedwczesny_druciak;
int statystyka;
long int sek21;
int sek21_wylaczenie_szlif;

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

sek13++;  //do czasu zatrzymania sie druciaka na gorze

sek20++;

sek80++;  //do kodu panela
sek21++;    //do wylaczenia szlifierki krazka sciernego przed klami

/*
if(PORTE.3 == 1)
      {
      czas_pracy_szczotki_drucianej++;
      czas_pracy_krazka_sciernego++;      
      if(czas_pracy_szczotki_drucianej == 61 * 60 * 60)
            {
            czas_pracy_szczotki_drucianej = 0;
            czas_pracy_szczotki_drucianej_h++;
            }
      if(czas_pracy_krazka_sciernego == 61 * 60 * 60)
            {
            czas_pracy_krazka_sciernego = 0;
            czas_pracy_krazka_sciernego_h++;
            }
      }


      //61 razy - 1s
      //61 * 60 - 1 minuta
      //61 * 60 * 60 - 1h

*/

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


void zaktualizuj_parametry_panelu()
{

/////////////////////////
//wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_stala,16,112);

//wartosc_parametru_panelu(czas_pracy_krazka_sciernego_stala,32,16);

//wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_h,0,144);

//wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_34,96,48);
//wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_36,96,64);
//wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_38,96,80);
//wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_41,96,96);
//wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_43,96,112);

//////////////////////////




if(zaaktualizuj_ilosc_rzad2 == 1)
    {
    wartosc_parametru_panelu(0,0,16);  //wykonano zaciskow rzad2
    zaaktualizuj_ilosc_rzad2 = 0;
    }
}

void komunikat_z_czytnika_kodow(char flash *fmtstr,int rzad, int na_plus_minus)
{
//na_plus_minus = 1;  to jest na plus
//na_plus_minus = 0;  to jest na minus

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


if(rzad == 1 & macierz_zaciskow[rzad]==0)
    {
    komunikat_na_panel("                                                ",144,80);//128,144
    komunikat_na_panel("Zacisk nie zmierzony u Wykonawcy",144,80);
    }

if(rzad == 1 & na_plus_minus == 1)
    {
    komunikat_na_panel("                                                ",144,80);  //128,144
    //komunikat_na_panel("Os zacisku blizej szafy",adres2,adres22);
    komunikat_na_panel("Kly w kierunku prawej strony",144,80);
    }
    
if(rzad == 1 & na_plus_minus == 0)
    {
    komunikat_na_panel("                                                ",144,80);  //128,144
    //komunikat_na_panel("Os zacisku dalej od szafy",adres2,adres22);
    komunikat_na_panel("Kly w kierunku lewej strony",144,80);
    }

    
if(rzad == 2 & na_plus_minus == 1)
    {
    komunikat_na_panel("                                                ",128,144);  //144,80
    //komunikat_na_panel("Os zacisku dalej od szafy",adres2,adres22);
    komunikat_na_panel("Kly w kierunku lewej strony",128,144);
    }

if(rzad == 2 & na_plus_minus == 0)
    {
    komunikat_na_panel("                                                ",128,144); //144,80
    //komunikat_na_panel("Os zacisku blizej szafy",adres2,adres22);
    komunikat_na_panel("Kly w kierunku prawej strony",128,144);
    }

if(rzad == 2 & macierz_zaciskow[rzad]==0)
    {
    komunikat_na_panel("                                                ",128,144);  //144,80
    komunikat_na_panel("Zacisk nie zmierzony u Wykonawcy",128,144);
    }


}

void zerowanie_pam_wew()
{
/*
if(czas_pracy_szczotki_drucianej_h >= 255 | czas_pracy_krazka_sciernego_h >=255 | czas_pracy_krazka_sciernego_stala >= 255 | czas_pracy_szczotki_drucianej_stala >= 255 |
   szczotka_druciana_ilosc_cykli >= 255 | krazek_scierny_ilosc_cykli >= 255 | krazek_scierny_cykl_po_okregu_ilosc >=255)
     {
     czas_pracy_szczotki_drucianej_h = 0;
     czas_pracy_szczotki_drucianej = 0; 
     czas_pracy_krazka_sciernego_h = 0;
     czas_pracy_krazka_sciernego = 0;
     czas_pracy_krazka_sciernego_stala = 5;
     czas_pracy_szczotki_drucianej_stala = 5;
     szczotka_druciana_ilosc_cykli = 3;
     krazek_scierny_ilosc_cykli = 3;
     krazek_scierny_cykl_po_okregu_ilosc = 3;
     }
*/

/*
if(czas_pracy_krazka_sciernego_h >= 255)
     {
     czas_pracy_krazka_sciernego_h = 0;
     czas_pracy_krazka_sciernego = 0;
     }
if(czas_pracy_krazka_sciernego_stala >= 255)
     czas_pracy_krazka_sciernego_stala = 5;

if(czas_pracy_szczotki_drucianej_stala >= 255)
     czas_pracy_szczotki_drucianej_stala = 5;

if(szczotka_druciana_ilosc_cykli >= 255)
   
if(krazek_scierny_ilosc_cykli >= 255)
   
if(krazek_scierny_cykl_po_okregu_ilosc >=255)
*/   

}


void odpytaj_parametry_panelu()
{
// to wylaczam tylko do testow w switniakch
if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0) 
    start = odczytaj_parametr(0,64);
il_zaciskow_rzad_1 = odczytaj_parametr(0,128); 
il_zaciskow_rzad_2 = odczytaj_parametr(0,48);



szczotka_druciana_ilosc_cykli = odczytaj_parametr(48,64);  
                                                //2090
krazek_scierny_ilosc_cykli = odczytaj_parametr(32,144);  
                                                    //3000
krazek_scierny_cykl_po_okregu_ilosc = odczytaj_parametr(48,0);  

//////////////////////////////////////////////
czas_pracy_szczotki_drucianej_stala = odczytaj_parametr(16,112);

czas_pracy_krazka_sciernego_stala = odczytaj_parametr(32,16);


czas_pracy_szczotki_drucianej_h_17 = odczytaj_parametr(0,144);
czas_pracy_szczotki_drucianej_h_15 = odczytaj_parametr(16,128);


czas_pracy_krazka_sciernego_h_34 = odczytaj_parametr(96,48);
czas_pracy_krazka_sciernego_h_36 = odczytaj_parametr(96,64);
czas_pracy_krazka_sciernego_h_38 = odczytaj_parametr(96,80);
czas_pracy_krazka_sciernego_h_41 = odczytaj_parametr(96,96);
czas_pracy_krazka_sciernego_h_43 = odczytaj_parametr(96,112);

//////////////////////////////////////////////////////////

test_geometryczny_rzad_1 = odczytaj_parametr(48,80);

test_geometryczny_rzad_2 = odczytaj_parametr(48,96);

srednica_krazka_sciernego = odczytaj_parametr(48,112);

ruch_haos = odczytaj_parametr(48,144);

tryb_pracy_szczotki_drucianej = odczytaj_parametr(0,112);
                                                //2050
//zerowanie_pam_wew();

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
//sprawdz_pin6(PORTLL,0x71)  S6A przek�adanie rzedow
//sprawdz_pin7(PORTLL,0x71)  S6B przekladanie rzedow

//IN4
//sprawdz_pin0(PORTMM,0x77) J2  czujnik indukcyjny domkniecia pokrywy
//sprawdz_pin1(PORTMM,0x77) J3  czujnik indukcyjny domkniecia pokrywy    
//sprawdz_pin2(PORTMM,0x77)     
//sprawdz_pin3(PORTMM,0x77)      
//sprawdz_pin4(PORTMM,0x77)   
//sprawdz_pin5(PORTMM,0x77)
//sprawdz_pin6(PORTMM,0x77) ALARM STEROWNIK4      
//sprawdz_pin7(PORTMM,0x77) ALARM STEROWNIK3  

//sterownik 1 i sterownik 3 - krazek scierny
//sterownik 2 i sterownik 4 - druciak

//OUT
//PORTA.0   IN0  STEROWNIK1        OUT 1
//PORTA.1   IN1  STEROWNIK1
//PORTA.2   IN2  STEROWNIK1
//PORTA.3   IN3  STEROWNIK1
//PORTA.4   IN4  STEROWNIK1
//PORTA.5   IN5  STEROWNIK1
//PORTA.6   IN6  STEROWNIK1
//PORTA.7   IN7  STEROWNIK1

//PORTB.0   IN0  STEROWNIK4        OUT 5
//PORTB.1   IN1  STEROWNIK4
//PORTB.2   IN2  STEROWNIK4
//PORTB.3   IN3  STEROWNIK4         
//PORTB.4   4B CEWKA przedmuch osi, byl, juz poloczone z B.6, teraz juz setup poziome
//PORTB.5   DRIVE  STEROWNIK4
//PORTB.6   swiatlo zielone
//PORTB.7   IN5 STEROWNIK 3                                                              

//PORTC.0   IN0  STEROWNIK2        OUT 3
//PORTC.1   IN1  STEROWNIK2
//PORTC.2   IN2  STEROWNIK2
//PORTC.3   IN3  STEROWNIK2
//PORTC.4   IN4  STEROWNIK2
//PORTC.5   IN5  STEROWNIK2
//PORTC.6   IN6  STEROWNIK2
//PORTC.7   IN7  STEROWNIK2

//PORTD.0  SDA                     OUT 2
//PORTD.1  SCL
//PORTD.2  SETUP   STEROWNIK1 STEROWNIK 2 STEROIWNIK 3 STEROWNIK 4
//PORTD.3  DRIVE   STEROWNIK1
//PORTD.4  IN8 STEROWNIK1
//PORTD.5  IN8 STEROWNIK2
//PORTD.6  DRIVE   STEROWNIK2
//PORTD.7  swiatlo czerwone i jednoczesnie HOLD

//PORTE.0      
//PORTE.1   
//PORTE.2  1A CEWKA szczotka druciana                    OUT 6
//PORTE.3  1B CEWKA krazek scierny
//PORTE.4  IN4  STEROWNIK4 
//PORTE.5  IN5  STEROWNIK4   ///////////////////////////////////////////////teraz tu b�dzie przedmuch kana� B 
//PORTE.6  2A CEWKA przerzucanie docisku zaciskow 
//PORTE.7  3A CEWKA zacisnij zaciski   

//PORTF.0   IN0  STEROWNIK3             OUT 4   
//PORTF.1   IN1  STEROWNIK3
//PORTF.2   IN2  STEROWNIK3
//PORTF.3   IN3  STEROWNIK3
//PORTF.4   4A CEWKA przedmuch zaciskow           
//PORTF.5   DRIVE  STEROWNIK3
//PORTF.6   swiatlo zolte
//PORTF.7   IN4 STEROWNIK 3                                                        



 //PORT_F.bits.b4 = 0;  //przedmuch zaciskow    
//PORTF = PORT_F.byte;  
//PORTB.6 = 1;  //przedmuch osi
//PORTE.2 = 1;  //szlifierka 1
//PORTE.3 = 1;  //szlifierka 2
//PORTE.6 = 0;  //zacisniety rzad 1
//PORTE.6 = 1;  //zacisniety rzad 2
//PORTE.7 = 0;    //zacisnij zaciski


//macierz_zaciskow[rzad]=44; brak
//macierz_zaciskow[rzad]=48; brak
//macierz_zaciskow[rzad]=76  brak  
//macierz_zaciskow[rzad]=80; brak 
//macierz_zaciskow[rzad]=92; brak  
//macierz_zaciskow[rzad]=96;  brak  
//macierz_zaciskow[rzad]=107; brak
//macierz_zaciskow[rzad]=111; brak 




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


PORTB.0 = 0;
PORTB.1 = 1;
PORTB.2 = 0;
PORTB.3 = 1;
PORTE.4 = 0;


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
i = 0;
//i = 1;

while(i == 0) 
    {
    if(sprawdz_pin6(PORTJJ,0x79) == 0)
        {
        i = 1;
        if(cisnienie_sprawdzone == 0)
            {
            komunikat_na_panel("                                                ",adr1,adr2);
            cisnienie_sprawdzone = 1;
            }
        
        }
    else
        {
        i = 0;
        cisnienie_sprawdzone = 0;
        komunikat_na_panel("                                                ",adr1,adr2);
        komunikat_na_panel("Cisnienie za male - mniejsze niz 6 bar",adr1,adr2);
        
        }
    }    
}


int odczyt_wybranego_zacisku()
{                         //11
int rzad;

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
    macierz_zaciskow[rzad]=1;  
    komunikat_z_czytnika_kodow("86-0170",rzad,1);
    srednica_wew_korpusu = 38;  
    }

if(PORT_CZYTNIK.byte == 0x02)
    {  
    macierz_zaciskow[rzad]=2; 
    komunikat_z_czytnika_kodow("86-1043",rzad,0);
    srednica_wew_korpusu = 34;  
    }

if(PORT_CZYTNIK.byte == 0x03)
    {
      macierz_zaciskow[rzad]=3; 
      komunikat_z_czytnika_kodow("86-1675",rzad,0);
      srednica_wew_korpusu =38;
    }

if(PORT_CZYTNIK.byte == 0x04)
    {
      
      macierz_zaciskow[rzad]=4;
      komunikat_z_czytnika_kodow("86-2098",rzad,0);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x05)
    {
      macierz_zaciskow[rzad]=5;
      komunikat_z_czytnika_kodow("87-0170",rzad,0);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x06)
    {
      macierz_zaciskow[rzad]=6;
      komunikat_z_czytnika_kodow("87-1043",rzad,1);
      srednica_wew_korpusu = 34;  
    }

if(PORT_CZYTNIK.byte == 0x07)
    {
      macierz_zaciskow[rzad]=7;
      komunikat_z_czytnika_kodow("87-1675",rzad,1);
      srednica_wew_korpusu = 38;  
    }

if(PORT_CZYTNIK.byte == 0x08)
    {
      macierz_zaciskow[rzad]=8;
      komunikat_z_czytnika_kodow("87-2098",rzad,1);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x09)
    {
      macierz_zaciskow[rzad]=9;
      komunikat_z_czytnika_kodow("86-0192",rzad,0);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x0A)
    {
      macierz_zaciskow[rzad]=10;
      komunikat_z_czytnika_kodow("86-1054",rzad,0);
      srednica_wew_korpusu = 41;  
    }
if(PORT_CZYTNIK.byte == 0x0B)
    {
      macierz_zaciskow[rzad]=11;
      komunikat_z_czytnika_kodow("86-1676",rzad,0);
      srednica_wew_korpusu = 41;  
    }
if(PORT_CZYTNIK.byte == 0x0C)
    {
      macierz_zaciskow[rzad]=12;
      komunikat_z_czytnika_kodow("86-2132",rzad,1);
      srednica_wew_korpusu = 41;  
    }
if(PORT_CZYTNIK.byte == 0x0D)
    {
      macierz_zaciskow[rzad]=13;
      komunikat_z_czytnika_kodow("87-0192",rzad,1);
      srednica_wew_korpusu = 38;   
    }
if(PORT_CZYTNIK.byte == 0x0E)
    {
      macierz_zaciskow[rzad]=14;
      komunikat_z_czytnika_kodow("87-1054",rzad,1);
      srednica_wew_korpusu = 41;  
    }

if(PORT_CZYTNIK.byte == 0x0F)
    {
      macierz_zaciskow[rzad]=15;
      komunikat_z_czytnika_kodow("87-1676",rzad,1);
      srednica_wew_korpusu = 41;  
    }
if(PORT_CZYTNIK.byte == 0x10)
    {
      macierz_zaciskow[rzad]=16;
      komunikat_z_czytnika_kodow("87-2132",rzad,0);
      srednica_wew_korpusu = 41;  
    }

if(PORT_CZYTNIK.byte == 0x11)
    {
      macierz_zaciskow[rzad]=17;
      komunikat_z_czytnika_kodow("86-0193",rzad,0);                 
      srednica_wew_korpusu = 38;
    }

if(PORT_CZYTNIK.byte == 0x12)
    {
      macierz_zaciskow[rzad]=18;
      komunikat_z_czytnika_kodow("86-1216",rzad,0);
      srednica_wew_korpusu = 34;  
    }
if(PORT_CZYTNIK.byte == 0x13)
    {
      macierz_zaciskow[rzad]=19;
      komunikat_z_czytnika_kodow("86-1832",rzad,0);
      srednica_wew_korpusu = 41;  
    }

if(PORT_CZYTNIK.byte == 0x14)
    {
      macierz_zaciskow[rzad]=20;
      komunikat_z_czytnika_kodow("86-2174",rzad,0);
      srednica_wew_korpusu = 34;  
    }
if(PORT_CZYTNIK.byte == 0x15)
    {
      macierz_zaciskow[rzad]=21;
      komunikat_z_czytnika_kodow("87-0193",rzad,1);
      srednica_wew_korpusu = 38;  
    }

if(PORT_CZYTNIK.byte == 0x16)
    {
      macierz_zaciskow[rzad]=22;
      komunikat_z_czytnika_kodow("87-1216",rzad,1);
      srednica_wew_korpusu = 34;  
    }
if(PORT_CZYTNIK.byte == 0x17)
    {
      macierz_zaciskow[rzad]=23;
      komunikat_z_czytnika_kodow("87-1832",rzad,1);
      srednica_wew_korpusu = 41;  
    }

if(PORT_CZYTNIK.byte == 0x18)
    {
      macierz_zaciskow[rzad]=24;
      komunikat_z_czytnika_kodow("87-2174",rzad,1);
      srednica_wew_korpusu = 34;  
    }
if(PORT_CZYTNIK.byte == 0x19)
    {
      macierz_zaciskow[rzad]=25;
      komunikat_z_czytnika_kodow("86-0194",rzad,0);
      srednica_wew_korpusu = 41;  
    }

if(PORT_CZYTNIK.byte == 0x1A)
    {
      macierz_zaciskow[rzad]=26;
      komunikat_z_czytnika_kodow("86-1341",rzad,0);
      srednica_wew_korpusu = 34;  
    }
if(PORT_CZYTNIK.byte == 0x1B)
    {
      macierz_zaciskow[rzad]=27;
      komunikat_z_czytnika_kodow("86-1833",rzad,0);
      srednica_wew_korpusu = 41;  
    }
if(PORT_CZYTNIK.byte == 0x1C)
    {
      macierz_zaciskow[rzad]=28;
      komunikat_z_czytnika_kodow("86-2180",rzad,1);
      srednica_wew_korpusu = 41;  
    }
if(PORT_CZYTNIK.byte == 0x1D)
    {
      macierz_zaciskow[rzad]=29;
      komunikat_z_czytnika_kodow("87-0194",rzad,1);
      srednica_wew_korpusu = 41;  
    }

if(PORT_CZYTNIK.byte == 0x1E)
    {
      macierz_zaciskow[rzad]=30;
      komunikat_z_czytnika_kodow("87-1341",rzad,1);
      srednica_wew_korpusu = 34;  
    }
if(PORT_CZYTNIK.byte == 0x1F)
    {
      macierz_zaciskow[rzad]=31;
      komunikat_z_czytnika_kodow("87-1833",rzad,1);
      srednica_wew_korpusu = 41;  
    }

if(PORT_CZYTNIK.byte == 0x20)
    {
      macierz_zaciskow[rzad]=32;
      komunikat_z_czytnika_kodow("87-2180",rzad,0);
      srednica_wew_korpusu = 41;  
    }
if(PORT_CZYTNIK.byte == 0x21)
    {
      macierz_zaciskow[rzad]=33;
      komunikat_z_czytnika_kodow("86-0663",rzad,1);
      srednica_wew_korpusu = 43;  
    }

if(PORT_CZYTNIK.byte == 0x22)
    {
      macierz_zaciskow[rzad]=34;
      komunikat_z_czytnika_kodow("86-1349",rzad,0);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x23)
    {
      macierz_zaciskow[rzad]=35;
      komunikat_z_czytnika_kodow("86-1834",rzad,0);
      srednica_wew_korpusu = 34;  
    }
if(PORT_CZYTNIK.byte == 0x24)
    {
      macierz_zaciskow[rzad]=36;
      komunikat_z_czytnika_kodow("86-2204",rzad,0);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x25)
    {
      macierz_zaciskow[rzad]=37;
      komunikat_z_czytnika_kodow("87-0663",rzad,0);
      srednica_wew_korpusu = 43;  
    }
if(PORT_CZYTNIK.byte == 0x26)
    {
      macierz_zaciskow[rzad]=38;
      komunikat_z_czytnika_kodow("87-1349",rzad,1);           
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x27)
    {
      macierz_zaciskow[rzad]=39;
      komunikat_z_czytnika_kodow("87-1834",rzad,1);
      srednica_wew_korpusu = 34;   
    }
if(PORT_CZYTNIK.byte == 0x28)
    {
      macierz_zaciskow[rzad]=40;
      komunikat_z_czytnika_kodow("87-2204",rzad,1);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x29)
    {
      macierz_zaciskow[rzad]=41;
      komunikat_z_czytnika_kodow("86-0768",rzad,1);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x2A)
    {
      macierz_zaciskow[rzad]=42;
      komunikat_z_czytnika_kodow("86-1357",rzad,0);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x2B)
    {
      macierz_zaciskow[rzad]=43;
      komunikat_z_czytnika_kodow("86-1848",rzad,0);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x2C)
    {
     macierz_zaciskow[rzad]=44;
      macierz_zaciskow[rzad]=0;   ////////////////////////////////////////////////////brak zacisku   
    
     komunikat_z_czytnika_kodow("86-2212",rzad,0);
     srednica_wew_korpusu = 38;
    }
if(PORT_CZYTNIK.byte == 0x2D)
    {
      macierz_zaciskow[rzad]=45; 
      komunikat_z_czytnika_kodow("87-0768",rzad,0);
      srednica_wew_korpusu = 38; 
    }
if(PORT_CZYTNIK.byte == 0x2E)
    {
      macierz_zaciskow[rzad]=46; 
      komunikat_z_czytnika_kodow("87-1357",rzad,1);
      srednica_wew_korpusu = 38; 
    }
if(PORT_CZYTNIK.byte == 0x2F)
    {
      macierz_zaciskow[rzad]=47;
      komunikat_z_czytnika_kodow("87-1848",rzad,1);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x30)
    {
      macierz_zaciskow[rzad]=48;
      macierz_zaciskow[rzad]=0;    /////////////////////////////////////////////////brak zacisku
      komunikat_z_czytnika_kodow("87-2212",rzad,1);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x31)
    {
      macierz_zaciskow[rzad]=49;
      komunikat_z_czytnika_kodow("86-0800",rzad,0);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x32)
    {
      macierz_zaciskow[rzad]=50;
      komunikat_z_czytnika_kodow("86-1363",rzad,0);
      srednica_wew_korpusu = 34;  
    }
if(PORT_CZYTNIK.byte == 0x33)
    {
      macierz_zaciskow[rzad]=51;
      komunikat_z_czytnika_kodow("86-1904",rzad,0);
      srednica_wew_korpusu = 43;  
    }
if(PORT_CZYTNIK.byte == 0x34)
    {
      macierz_zaciskow[rzad]=52;
      komunikat_z_czytnika_kodow("86-2241",rzad,1);
      srednica_wew_korpusu = 34;  
    }
if(PORT_CZYTNIK.byte == 0x35)
    {
      macierz_zaciskow[rzad]=53;
      komunikat_z_czytnika_kodow("87-0800",rzad,1);
      srednica_wew_korpusu = 38;  
    }

if(PORT_CZYTNIK.byte == 0x36)
    {
      macierz_zaciskow[rzad]=54;
      komunikat_z_czytnika_kodow("87-1363",rzad,1);
      srednica_wew_korpusu = 34;  
    }
if(PORT_CZYTNIK.byte == 0x37)
    {
      macierz_zaciskow[rzad]=55;
      komunikat_z_czytnika_kodow("87-1904",rzad,1);
      srednica_wew_korpusu = 43;  
    }
if(PORT_CZYTNIK.byte == 0x38)
    {
      macierz_zaciskow[rzad]=56;
      komunikat_z_czytnika_kodow("87-2241",rzad,0);
      srednica_wew_korpusu = 34;  
    }
if(PORT_CZYTNIK.byte == 0x39)
    {
      macierz_zaciskow[rzad]=57;
      komunikat_z_czytnika_kodow("86-0811",rzad,0);
      srednica_wew_korpusu = 34;  
    }
if(PORT_CZYTNIK.byte == 0x3A)
    {
      macierz_zaciskow[rzad]=58;
      komunikat_z_czytnika_kodow("86-1523",rzad,0);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x3B)
    {
      macierz_zaciskow[rzad]=59;
      komunikat_z_czytnika_kodow("86-1929",rzad,0);
      srednica_wew_korpusu = 41;  
    }
if(PORT_CZYTNIK.byte == 0x3C)
    {
      macierz_zaciskow[rzad]=60;
      komunikat_z_czytnika_kodow("86-2261",rzad,0);
      srednica_wew_korpusu = 34;  
    }
if(PORT_CZYTNIK.byte == 0x3D)
    {
      macierz_zaciskow[rzad]=61;
      komunikat_z_czytnika_kodow("87-0811",rzad,1);
      srednica_wew_korpusu = 34;  
    }
if(PORT_CZYTNIK.byte == 0x3E)
    {
      macierz_zaciskow[rzad]=62;
      komunikat_z_czytnika_kodow("87-1523",rzad,1);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x3F)
    {
      macierz_zaciskow[rzad]=63;
      komunikat_z_czytnika_kodow("87-1929",rzad,1);
      srednica_wew_korpusu = 41;  
    }
if(PORT_CZYTNIK.byte == 0x40)
    {
      macierz_zaciskow[rzad]=64;
      komunikat_z_czytnika_kodow("87-2261",rzad,1);
      srednica_wew_korpusu = 34;   
    }
if(PORT_CZYTNIK.byte == 0x41)
    {
      macierz_zaciskow[rzad]=65;
      komunikat_z_czytnika_kodow("86-0814",rzad,0);
      srednica_wew_korpusu = 36;  
    }
if(PORT_CZYTNIK.byte == 0x42)
    {
      macierz_zaciskow[rzad]=66;
      komunikat_z_czytnika_kodow("86-1530",rzad,1);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x43)
    {
      macierz_zaciskow[rzad]=67;
      komunikat_z_czytnika_kodow("86-1936",rzad,1);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x44)
    {
      macierz_zaciskow[rzad]=68;
      komunikat_z_czytnika_kodow("86-2285",rzad,1);
      srednica_wew_korpusu = 41;  
    }
if(PORT_CZYTNIK.byte == 0x45)
    {
      macierz_zaciskow[rzad]=69;
      komunikat_z_czytnika_kodow("87-0814",rzad,1);
      srednica_wew_korpusu = 36;  
    }
if(PORT_CZYTNIK.byte == 0x46)
    {
      macierz_zaciskow[rzad]=70;
      komunikat_z_czytnika_kodow("87-1530",rzad,0);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x47)
    {
      macierz_zaciskow[rzad]=71;
      komunikat_z_czytnika_kodow("87-1936",rzad,0);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x48)
    {
      macierz_zaciskow[rzad]=72;
      komunikat_z_czytnika_kodow("87-2285",rzad,0);
      srednica_wew_korpusu = 41;  
    }
if(PORT_CZYTNIK.byte == 0x49)
    {
      macierz_zaciskow[rzad]=73;
      komunikat_z_czytnika_kodow("86-0815",rzad,0);
      srednica_wew_korpusu = 38;  
    }

if(PORT_CZYTNIK.byte == 0x4A)
    {
      macierz_zaciskow[rzad]=74;
      komunikat_z_czytnika_kodow("86-1551",rzad,0);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x4B)
    {
      macierz_zaciskow[rzad]=75;
      komunikat_z_czytnika_kodow("86-1941",rzad,0);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x4C)
    {
      macierz_zaciskow[rzad]=76;
      macierz_zaciskow[rzad]=0;    ////////////////////////////////brak zacisku
      komunikat_z_czytnika_kodow("86-2286",rzad,0);
      srednica_wew_korpusu = 41;  
    }
if(PORT_CZYTNIK.byte == 0x4D)
    {
      macierz_zaciskow[rzad]=77;
      komunikat_z_czytnika_kodow("87-0815",rzad,1);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x4E)
    {
      macierz_zaciskow[rzad]=78;
      komunikat_z_czytnika_kodow("87-1551",rzad,1);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x4F)
    {
      macierz_zaciskow[rzad]=79;
      komunikat_z_czytnika_kodow("87-1941",rzad,1);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x50)
    {
      macierz_zaciskow[rzad]=80;
      macierz_zaciskow[rzad]=0;  ////////////////////////////////////////////////////////////////////////brak zacisku
      komunikat_z_czytnika_kodow("87-2286",rzad,0);
      srednica_wew_korpusu = 41;   
    }
if(PORT_CZYTNIK.byte == 0x51)
    {
      macierz_zaciskow[rzad]=81;
      komunikat_z_czytnika_kodow("86-0816",rzad,0);
      srednica_wew_korpusu = 36;   
    }
if(PORT_CZYTNIK.byte == 0x52)
    {
      macierz_zaciskow[rzad]=82;
      komunikat_z_czytnika_kodow("86-1552",rzad,0);
      srednica_wew_korpusu = 34;  
    }
if(PORT_CZYTNIK.byte == 0x53)
    {
      macierz_zaciskow[rzad]=83;
      komunikat_z_czytnika_kodow("86-2007",rzad,1);
      srednica_wew_korpusu = 41;  
    }
if(PORT_CZYTNIK.byte == 0x54)
    {
      macierz_zaciskow[rzad]=84;
      komunikat_z_czytnika_kodow("86-2292",rzad,1);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x55)
    {
      macierz_zaciskow[rzad]=85;
      komunikat_z_czytnika_kodow("87-0816",rzad,1);
      srednica_wew_korpusu = 36;  
     }
if(PORT_CZYTNIK.byte == 0x56)
    {
      macierz_zaciskow[rzad]=86;
      komunikat_z_czytnika_kodow("87-1552",rzad,1);
      srednica_wew_korpusu = 34;  
    }
if(PORT_CZYTNIK.byte == 0x57)
    {
      macierz_zaciskow[rzad]=87;
      komunikat_z_czytnika_kodow("87-2007",rzad,0);
      srednica_wew_korpusu = 41;  
    }
if(PORT_CZYTNIK.byte == 0x58)
    {
      macierz_zaciskow[rzad]=88;
      komunikat_z_czytnika_kodow("87-2292",rzad,0);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x59)
    {
      macierz_zaciskow[rzad]=89;
      komunikat_z_czytnika_kodow("86-0817",rzad,0);
      srednica_wew_korpusu = 38;
    }  
if(PORT_CZYTNIK.byte == 0x5A)
    {
      macierz_zaciskow[rzad]=90;
      komunikat_z_czytnika_kodow("86-1602",rzad,1);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x5B)
    {
      macierz_zaciskow[rzad]=91;
      komunikat_z_czytnika_kodow("86-2017",rzad,1);
      srednica_wew_korpusu = 41;  
    }
if(PORT_CZYTNIK.byte == 0x5C)
    {
      macierz_zaciskow[rzad]=92;
      macierz_zaciskow[rzad]=0;           /////////////////////////////////////////brak zacisku
      komunikat_z_czytnika_kodow("86-2384",rzad,0);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x5D)
    {
      macierz_zaciskow[rzad]=93;
      komunikat_z_czytnika_kodow("87-0817",rzad,1);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x5E)
    {
      macierz_zaciskow[rzad]=94;
      komunikat_z_czytnika_kodow("87-1602",rzad,0);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x5F)
    {
      macierz_zaciskow[rzad]=95;
      komunikat_z_czytnika_kodow("87-2017",rzad,0);
      srednica_wew_korpusu = 41;  
    }
if(PORT_CZYTNIK.byte == 0x60)
    {
      macierz_zaciskow[rzad]=96;   ///////////////////////////////////////////////brak zacisku
      macierz_zaciskow[rzad]=0;
      komunikat_z_czytnika_kodow("87-2384",rzad,0);
      srednica_wew_korpusu = 38;  
    }

if(PORT_CZYTNIK.byte == 0x61)
    {
      macierz_zaciskow[rzad]=97;
      komunikat_z_czytnika_kodow("86-0847",rzad,0);
      srednica_wew_korpusu = 41;  
    }

if(PORT_CZYTNIK.byte == 0x62)
    {
      macierz_zaciskow[rzad]=98;
      komunikat_z_czytnika_kodow("86-1620",rzad,0);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x63)
    {
      macierz_zaciskow[rzad]=99;
      komunikat_z_czytnika_kodow("86-2019",rzad,1);
      srednica_wew_korpusu = 41;  
    }
if(PORT_CZYTNIK.byte == 0x64)
    {
      macierz_zaciskow[rzad]=100;
      komunikat_z_czytnika_kodow("86-2385",rzad,0);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x65)
    {
      macierz_zaciskow[rzad]=101;
      komunikat_z_czytnika_kodow("87-0847",rzad,1);
      srednica_wew_korpusu = 41;  
    }
if(PORT_CZYTNIK.byte == 0x66)
    {
      macierz_zaciskow[rzad]=102;
      komunikat_z_czytnika_kodow("87-1620",rzad,1);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x67)
    {
      macierz_zaciskow[rzad]=103;
      komunikat_z_czytnika_kodow("87-2019",rzad,0);
      srednica_wew_korpusu = 41;  
    }
if(PORT_CZYTNIK.byte == 0x68)
    {
      macierz_zaciskow[rzad]=104;
      komunikat_z_czytnika_kodow("87-2385",rzad,1);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x69)
    {
      macierz_zaciskow[rzad]=105;
      komunikat_z_czytnika_kodow("86-0854",rzad,0);
      srednica_wew_korpusu = 34;  
    }
if(PORT_CZYTNIK.byte == 0x6A)
    {
      macierz_zaciskow[rzad]=106;
      komunikat_z_czytnika_kodow("86-1622",rzad,1);
      srednica_wew_korpusu = 34;  
    }
if(PORT_CZYTNIK.byte == 0x6B)
    {
      macierz_zaciskow[rzad]=107;
      macierz_zaciskow[rzad]=0;          //brak zacisku
      komunikat_z_czytnika_kodow("86-2028",rzad,0);
      srednica_wew_korpusu = 43;  
    }
if(PORT_CZYTNIK.byte == 0x6C)
    {
      macierz_zaciskow[rzad]=108;
      komunikat_z_czytnika_kodow("86-2437",rzad,0);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x6D)
    {
      macierz_zaciskow[rzad]=109;
      komunikat_z_czytnika_kodow("87-0854",rzad,1);
      srednica_wew_korpusu = 34;   
    }
if(PORT_CZYTNIK.byte == 0x6E)
    {
      macierz_zaciskow[rzad]=110;
      komunikat_z_czytnika_kodow("87-1622",rzad,0);
      srednica_wew_korpusu = 34;  
    }

if(PORT_CZYTNIK.byte == 0x6F)
    {
      macierz_zaciskow[rzad]=111;
      macierz_zaciskow[rzad]=0;      //brak zacisku
      komunikat_z_czytnika_kodow("87-2028",rzad,0);
      srednica_wew_korpusu = 43;  
    }

if(PORT_CZYTNIK.byte == 0x70)
    {
      macierz_zaciskow[rzad]=112;
      komunikat_z_czytnika_kodow("87-2437",rzad,1);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x71)
    {
      macierz_zaciskow[rzad]=113;
      komunikat_z_czytnika_kodow("86-0862",rzad,0);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x72)
    {
      macierz_zaciskow[rzad]=114;
      komunikat_z_czytnika_kodow("86-1625",rzad,0);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x73)
    {
      macierz_zaciskow[rzad]=115;
      komunikat_z_czytnika_kodow("86-2052",rzad,0);
      srednica_wew_korpusu = 43;  
    }
if(PORT_CZYTNIK.byte == 0x74)
    {
      macierz_zaciskow[rzad]=116;
      komunikat_z_czytnika_kodow("86-2492",rzad,1);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x75)
    {
      macierz_zaciskow[rzad]=117;
      komunikat_z_czytnika_kodow("87-0862",rzad,1);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x76)
    {
      macierz_zaciskow[rzad]=118;
      komunikat_z_czytnika_kodow("87-1625",rzad,1);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x77)
    {
      macierz_zaciskow[rzad]=119;
      komunikat_z_czytnika_kodow("87-2052",rzad,1);
      srednica_wew_korpusu = 43;  
    }
if(PORT_CZYTNIK.byte == 0x78)
    {
      macierz_zaciskow[rzad]=120;
      komunikat_z_czytnika_kodow("87-2492",rzad,0);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x79)
    {
      macierz_zaciskow[rzad]=121;
      komunikat_z_czytnika_kodow("86-0935",rzad,0);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x7A)
    {
      macierz_zaciskow[rzad]=122;
      komunikat_z_czytnika_kodow("86-1648",rzad,0);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x7B)
    {
      macierz_zaciskow[rzad]=123;
      komunikat_z_czytnika_kodow("86-2082",rzad,0);
      srednica_wew_korpusu = 36;  
    }
if(PORT_CZYTNIK.byte == 0x7C)
    {
      macierz_zaciskow[rzad]=124;
      komunikat_z_czytnika_kodow("86-2500",rzad,0);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x7D)
    {
      macierz_zaciskow[rzad]=125;
      komunikat_z_czytnika_kodow("87-0935",rzad,1);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x7E)
    {
      macierz_zaciskow[rzad]=126;
      komunikat_z_czytnika_kodow("87-1648",rzad,1);
      srednica_wew_korpusu = 38;  
    }

if(PORT_CZYTNIK.byte == 0x7F)
    {
      macierz_zaciskow[rzad]=127;
      komunikat_z_czytnika_kodow("87-2082",rzad,1);
      srednica_wew_korpusu = 36;  
    }
if(PORT_CZYTNIK.byte == 0x80)
    {
      macierz_zaciskow[rzad]=128;
      komunikat_z_czytnika_kodow("87-2500",rzad,1);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x81)
    {
      macierz_zaciskow[rzad]=129;
      komunikat_z_czytnika_kodow("86-1019",rzad,0);
      srednica_wew_korpusu = 41;  
    }
if(PORT_CZYTNIK.byte == 0x82)
    {
      macierz_zaciskow[rzad]=130;
      komunikat_z_czytnika_kodow("86-1649",rzad,0);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x83)
    {
      macierz_zaciskow[rzad]=131;
      komunikat_z_czytnika_kodow("86-2083",rzad,1);
      srednica_wew_korpusu = 43;  
    }
if(PORT_CZYTNIK.byte == 0x84)
    {
      macierz_zaciskow[rzad]=132;
      komunikat_z_czytnika_kodow("86-2585",rzad,0);
      srednica_wew_korpusu = 43;  
    }
if(PORT_CZYTNIK.byte == 0x85)
    {
      macierz_zaciskow[rzad]=133;
      komunikat_z_czytnika_kodow("87-1019",rzad,1);
      srednica_wew_korpusu = 41;  
    }
if(PORT_CZYTNIK.byte == 0x86)
    {
      macierz_zaciskow[rzad]=134;
      komunikat_z_czytnika_kodow("87-1649",rzad,1);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x87)
    {
      macierz_zaciskow[rzad]=135;
      komunikat_z_czytnika_kodow("87-2083",rzad,0);
      srednica_wew_korpusu = 43;  
    }

if(PORT_CZYTNIK.byte == 0x88)
    {
      macierz_zaciskow[rzad]=136;
      komunikat_z_czytnika_kodow("87-2624",rzad,1);
      srednica_wew_korpusu = 34;  
    }
if(PORT_CZYTNIK.byte == 0x89)
    {
      macierz_zaciskow[rzad]=137;
      komunikat_z_czytnika_kodow("86-1027",rzad,0);
      srednica_wew_korpusu = 34;  
    }
if(PORT_CZYTNIK.byte == 0x8A)
    {
      macierz_zaciskow[rzad]=138;
      komunikat_z_czytnika_kodow("86-1669",rzad,1);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x8B)
    {
      macierz_zaciskow[rzad]=139;
      komunikat_z_czytnika_kodow("86-2087",rzad,1);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x8C)
    {
      macierz_zaciskow[rzad]=140;
      komunikat_z_czytnika_kodow("86-2624",rzad,0);
      srednica_wew_korpusu = 34;  
    }
if(PORT_CZYTNIK.byte == 0x8D)
    {
      macierz_zaciskow[rzad]=141;
      komunikat_z_czytnika_kodow("87-1027",rzad,1);
      srednica_wew_korpusu = 34;  
    }
if(PORT_CZYTNIK.byte == 0x8E)
    {
      macierz_zaciskow[rzad]=142;
      komunikat_z_czytnika_kodow("87-1669",rzad,0);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x8F)
    {
      macierz_zaciskow[rzad]=143;
      komunikat_z_czytnika_kodow("87-2087",rzad,0);
      srednica_wew_korpusu = 38;  
    }
if(PORT_CZYTNIK.byte == 0x90)
    {
      macierz_zaciskow[rzad]=144;
      komunikat_z_czytnika_kodow("87-2585",rzad,1);
      srednica_wew_korpusu = 43;  
    }


return rzad;
}


void wybor_linijek_sterownikow(int rzad_local)
{
//zaczynam od tego
//komentarz: celowo upraszam:
//  a[2] = 0x22;    //ster4 ABS             //1,0,0,0,1,0  druciak    (1,0,0,0,1,0); 
//a[4] = 0x21;    //ster3 ABS             //krazek scierny

//legenda pierwotna
            /*
            a[0] = 0x05A;   //ster1       
            a[1] = a[0]+0x001;                                   //0x05B;   //ster2 
            a[2] = 0x22;    //ster4 ABS             //1,0,0,0,1,0  druciak    (1,0,0,0,1,0); 
            a[3] = 0x11;    //ster4 INV             //druciak
            a[4] = a[2];   //0x21;    //ster3 ABS             //krazek scierny
            a[5] = 0x196;   //delta okrag
            a[6] = a[5]+0x001;            //0x197;   //okrag
            a[7] = 0x12;    //ster3 INV             krazek scierny
            a[8] = a[6]+0x001;                0x198;   //-delta okrag
            a[9] = 0;          //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            */


//macierz_zaciskow[rzad_local]
//macierz_zaciskow[rzad_local] = 140;






switch(macierz_zaciskow[rzad_local])
{
    case 0:
           
            komunikat_na_panel("                                                ",adr1,adr2);
            komunikat_na_panel("Nie wczytano zacisku",adr1,adr2);
    
    break;
    
    
     case 1: 
            
            a[0] = 0x0C8;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1B;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x11;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
      case 2: 
            
            a[0] = 0x110;   //ster1         
            a[3] = 0x10;    //ster4 INV druciak
            a[4] = 0x1C;    //ster3 ABS krazek scierny
            a[5] = 0x190;   //delta okrag
            a[7] = 0x10;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
      case 3: 
            
            a[0] = 0x07A;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x18;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
      case 4: 
            
            a[0] = 0x102;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1F;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
      case 5: 
            
            a[0] = 0x0B0;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1B;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x11;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
      case 6: 
            
            a[0] = 0x0FE;   //ster1         
            a[3] = 0x10;    //ster4 INV druciak
            a[4] = 0x1C;    //ster3 ABS krazek scierny
            a[5] = 0x190;   //delta okrag
            a[7] = 0x10;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
      case 7: 
            
            a[0] = 0x078;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x18;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
      case 8: 
            
            a[0] = 0x0C0;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1F;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
      case 9: 
            
            a[0] = 0x018;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1F;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x11;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
      case 10: 
            
            a[0] = 0x016;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1F;    //ster3 ABS krazek scierny
            a[5] = 0x199;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
      case 11: 
            
            a[0] = 0x074;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x19;    //ster3 ABS krazek scierny
            a[5] = 0x199;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
      case 12: 
            
            a[0] = 0x096;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x21;    //ster3 ABS krazek scierny
            a[5] = 0x199;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
      case 13: 
            
            a[0] = 0x01A;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1F;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x11;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
      case 14: 
            
            a[0] = 0x05E;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1F;    //ster3 ABS krazek scierny
            a[5] = 0x199;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
      case 15: 
            
            a[0] = 0x084;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x19;    //ster3 ABS krazek scierny
            a[5] = 0x199;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
      case 16: 
            
            a[0] = 0x0B8;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x20;    //ster3 ABS krazek scierny
            a[5] = 0x199;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
      case 17: 
            
            a[0] = 0x020;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1B;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x11;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
      case 18: 
            
            a[0] = 0x098;   //ster1         
            a[3] = 0x10;    //ster4 INV druciak
            a[4] = 0x16;    //ster3 ABS krazek scierny
            a[5] = 0x190;   //delta okrag
            a[7] = 0x10;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
    
      case 19: 
            
            a[0] = 0x0AA;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1D;    //ster3 ABS krazek scierny
            a[5] = 0x199;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
      case 20: 
            
            a[0] = 0x042;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1D;    //ster3 ABS krazek scierny
            a[5] = 0x190;   //delta okrag
            a[7] = 0x0F;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
      case 21: 
            
            a[0] = 0x04E;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1B;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x11;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
      case 22: 
            
            a[0] = 0x0C2;   //ster1         
            a[3] = 0x10;    //ster4 INV druciak
            a[4] = 0x16;    //ster3 ABS krazek scierny
            a[5] = 0x190;   //delta okrag
            a[7] = 0x10;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
      case 23: 
            
            a[0] = 0x0CE;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1D;    //ster3 ABS krazek scierny
            a[5] = 0x199;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
      case 24: 
            
            a[0] = 0x040;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1D;    //ster3 ABS krazek scierny
            a[5] = 0x190;   //delta okrag
            a[7] = 0x0F;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
      case 25: 
            
            a[0] = 0x02E;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1F;    //ster3 ABS krazek scierny
            a[5] = 0x199;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
      case 26: 
            
            a[0] = 0x0FA;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x18;    //ster3 ABS krazek scierny
            a[5] = 0x190;   //delta okrag
            a[7] = 0x11;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
      case 27: 
            
            a[0] = 0x06C;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x20;    //ster3 ABS krazek scierny
            a[5] = 0x199;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
      case 28: 
            
            a[0] = 0x0A4;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x21;    //ster3 ABS krazek scierny
            a[5] = 0x199;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
      case 29: 
            
            a[0] = 0x02A;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1F;    //ster3 ABS krazek scierny
            a[5] = 0x199;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
            
            
            
            
            
    break;
    
      case 30: 
            
            a[0] = 0x094;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x18;    //ster3 ABS krazek scierny
            a[5] = 0x190;   //delta okrag
            a[7] = 0x11;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
      case 31: 
            
            a[0] = 0x06E;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x20;    //ster3 ABS krazek scierny
            a[5] = 0x199;   //delta okrag
            a[7] = 0x12;  //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
       case 32: 
            
            a[0] = 0x086;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x21;    //ster3 ABS krazek scierny
            a[5] = 0x199;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
       case 33: 
            
            a[0] = 0x08E;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x20;    //ster3 ABS krazek scierny
            a[5] = 0x19C;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
    case 34: //86-1349
            
            a[0] = 0x05A;   //ster1         
            a[3] = 0x11- 0x01;    //ster4 INV druciak
            a[4] = 0x21;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 0;       //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
    case 35: 
            
            a[0] = 0x0DA;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1E;    //ster3 ABS krazek scierny
            a[5] = 0x190;   //delta okrag
            a[7] = 0x0F;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
         case 36: 
            
            a[0] = 0x0A2;   //ster1         
            a[3] = 0x12;    //ster4 INV druciak
            a[4] = 0x22;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x10;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
         case 37: 
            
            a[0] = 0x104;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x21;    //ster3 ABS krazek scierny
            a[5] = 0x19C;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
         case 38: 
            
            a[0] = 0x036;   //ster1         
            a[3] = 0x11 - 0x01;    //ster4 INV druciak  //korekta
            a[4] = 0x21;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
         case 39: 
            
            a[0] = 0x118;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1E;    //ster3 ABS krazek scierny
            a[5] = 0x190;   //delta okrag
            a[7] = 0x0F;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
         case 40: 
            
            a[0] = 0x0A6;   //ster1         
            a[3] = 0x12;    //ster4 INV druciak
            a[4] = 0x22;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x10;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
         case 41: 
            
            a[0] = 0x01E;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1F;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x11;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
         case 42: 
            
            a[0] = 0x05C;   //ster1         
            a[3] = 0x10;    //ster4 INV druciak
            a[4] = 0x1E;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x11;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
         case 43: 
            
            a[0] = 0x062;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x20;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
         case 44: 
            
            a[0] = 0x;   //ster1         
            a[3] = 0x;    //ster4 INV druciak
            a[4] = 0x;    //ster3 ABS krazek scierny
            a[5] = 0x;   //delta okrag
            a[7] = 0x;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
         case 45: 
            
            a[0] = 0x010;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1F;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x11;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
    case 46: 
            
            a[0] = 0x050;   //ster1         
            a[3] = 0x10;    //ster4 INV druciak
            a[4] = 0x1E;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x11;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
    case 47: 
            
            a[0] = 0x068;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x20;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
    
    case 48: 
            
            a[0] = 0x;   //ster1         
            a[3] = 0x;    //ster4 INV druciak
            a[4] = 0x;    //ster3 ABS krazek scierny
            a[5] = 0x;   //delta okrag
            a[7] = 0x;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
    case 49: 
            
            a[0] = 0x024;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1F;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
    case 50: 
            
            a[0] = 0x014;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1E;    //ster3 ABS krazek scierny
            a[5] = 0x190;   //delta okrag
            a[7] = 0x0F;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    case 51: 
            
            a[0] = 0x082;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1B;    //ster3 ABS krazek scierny
            a[5] = 0x19C;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    case 52: 
            
            a[0] = 0x106;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x19;    //ster3 ABS krazek scierny
            a[5] = 0x190;   //delta okrag
            a[7] = 0x13;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
    case 53: 
            
            a[0] = 0x04C;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1F;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
    case 54: 
            
            a[0] = 0x01C;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1E;    //ster3 ABS krazek scierny
            a[5] = 0x190;   //delta okrag
            a[7] = 0x0F;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    case 55: 
            
            a[0] = 0x114;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1A;    //ster3 ABS krazek scierny
            a[5] = 0x19C;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
    case 56: 
            
            a[0] = 0x0EE;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x19;    //ster3 ABS krazek scierny
            a[5] = 0x190;   //delta okrag
            a[7] = 0x13;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
    case 57: 
            
            a[0] = 0x0F8;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x19;    //ster3 ABS krazek scierny
            a[5] = 0x190;   //delta okrag
            a[7] = 0x11;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
    case 58: 
            
            a[0] = 0x0E4;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x20;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
    case 59: 
            
            a[0] = 0x052;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1C;    //ster3 ABS krazek scierny
            a[5] = 0x199;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
    case 60: 
            
            a[0] = 0x090;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1A;    //ster3 ABS krazek scierny
            a[5] = 0x190;   //delta okrag
            a[7] = 0x11;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
    case 61: 
            
            a[0] = 0x0FC;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x18;    //ster3 ABS krazek scierny
            a[5] = 0x190;   //delta okrag
            a[7] = 0x11;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
    case 62: 
            
            a[0] = 0x028;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x20;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
    case 63: 
            
            a[0] = 0x034;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1C;    //ster3 ABS krazek scierny
            a[5] = 0x199;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
    case 64: 
            
            a[0] = 0x0EC;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x19;    //ster3 ABS krazek scierny
            a[5] = 0x190;   //delta okrag
            a[7] = 0x11;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
    case 65: 
            
            a[0] = 0x0CC;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x16;    //ster3 ABS krazek scierny
            a[5] = 0x193;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
    case 66: 
            
            a[0] = 0x0BC;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1C;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x11;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
    case 67: 
            
            a[0] = 0x09C;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1C;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
    case 68: 
            
            a[0] = 0x07C;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x21;    //ster3 ABS krazek scierny
            a[5] = 0x199;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
    case 69: 
            
            a[0] = 0x0D2;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x16;    //ster3 ABS krazek scierny
            a[5] = 0x193;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
    case 70: 
            
            a[0] = 0x0E6;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1C;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x11;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
    case 71: 
            
            a[0] = 0x0B4;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1C;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
    case 72: 
            
            a[0] = 0x0AC;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x21;    //ster3 ABS krazek scierny
            a[5] = 0x199;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
    case 73: 
            
            a[0] = 0x012;   //ster1         
            a[3] = 0x10;    //ster4 INV druciak
            a[4] = 0x1B;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
    case 74: 
            
            a[0] = 0x0B2;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1F;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
    case 75: 
            
            a[0] = 0x10C;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x21;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
    case 76: 
            
            a[0] = 0x;   //ster1         
            a[3] = 0x;    //ster4 INV druciak
            a[4] = 0x;    //ster3 ABS krazek scierny
            a[5] = 0x;   //delta okrag
            a[7] = 0x;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
    case 77: 
            
            a[0] = 0x026;   //ster1         
            a[3] = 0x10;    //ster4 INV druciak
            a[4] = 0x1B;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
    case 78: 
            
            a[0] = 0x11C;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1E;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
    case 79: 
            
            a[0] = 0x112;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x21;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    case 80: 
            
            a[0] = 0x;   //ster1         
            a[3] = 0x;    //ster4 INV druciak
            a[4] = 0x;    //ster3 ABS krazek scierny
            a[5] = 0x;   //delta okrag
            a[7] = 0x;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    case 81: 
            
            a[0] = 0x0EA;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x19;    //ster3 ABS krazek scierny
            a[5] = 0x193;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
    case 82: 
            
            a[0] = 0x0D8;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x14;    //ster3 ABS krazek scierny
            a[5] = 0x190;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
    case 83: 
            
            a[0] = 0x08C;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x22;    //ster3 ABS krazek scierny
            a[5] = 0x199;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
    case 84: 
            
            a[0] = 0x0A0;   //ster1         
            a[3] = 0x12;    //ster4 INV druciak
            a[4] = 0x24;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x10;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break;
    
    
   case 85: 
            
            a[0] = 0x0AE;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x19;    //ster3 ABS krazek scierny
            a[5] = 0x193;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    case 86: 
            
            a[0] = 0x0F6;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x14;    //ster3 ABS krazek scierny
            a[5] = 0x190;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 87: 
            
            a[0] = 0x0C4;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x23;    //ster3 ABS krazek scierny
            a[5] = 0x199;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 88: 
            
            a[0] = 0x07E;   //ster1         
            a[3] = 0x12;    //ster4 INV druciak
            a[4] = 0x24;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x10;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 89: 
            
            a[0] = 0x02C;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1A;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 90: 
            
            a[0] = 0x0F0;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1B;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x11;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 91: 
            
            a[0] = 0x0A8;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x20;    //ster3 ABS krazek scierny
            a[5] = 0x199;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 92: 
            
            a[0] = 0x;   //ster1         
            a[3] = 0x;    //ster4 INV druciak
            a[4] = 0x;    //ster3 ABS krazek scierny
            a[5] = 0x;   //delta okrag
            a[7] = 0x;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 93: 
            
            a[0] = 0x030;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1A;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 94: 
            
            a[0] = 0x0F4;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1B;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x11;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 95: 
            
            a[0] = 0x09E;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x20;    //ster3 ABS krazek scierny
            a[5] = 0x199;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    case 96: 
            
            a[0] = 0x;   //ster1         
            a[3] = 0x;    //ster4 INV druciak
            a[4] = 0x;    //ster3 ABS krazek scierny
            a[5] = 0x;   //delta okrag
            a[7] = 0x;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 97: 
            
            a[0] = 0x06A;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x21;    //ster3 ABS krazek scierny
            a[5] = 0x199;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 98: 
            
            a[0] = 0x0BE;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x18;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x0F;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 99: 
            
            a[0] = 0x0BA;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1E;    //ster3 ABS krazek scierny
            a[5] = 0x199;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 100: 
            
            a[0] = 0x060;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1F;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 101: 
            
            a[0] = 0x070;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x21;    //ster3 ABS krazek scierny
            a[5] = 0x199;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 102: 
            
            a[0] = 0x08A;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x18;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x0F;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 103: 
            
            a[0] = 0x080;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1E;    //ster3 ABS krazek scierny
            a[5] = 0x199;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 104: 
            
            a[0] = 0x0B6;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1F;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 105: 
            
            a[0] = 0x044;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1F;    //ster3 ABS krazek scierny
            a[5] = 0x190;   //delta okrag
            a[7] = 0x0F;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 106: 
            
            a[0] = 0x03A;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1E;    //ster3 ABS krazek scierny
            a[5] = 0x190;   //delta okrag
            a[7] = 0x0F;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 107: 
            
            a[0] = 0x;   //ster1         
            a[3] = 0x;    //ster4 INV druciak
            a[4] = 0x;    //ster3 ABS krazek scierny
            a[5] = 0x;   //delta okrag
            a[7] = 0x;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 108: 
            
            a[0] = 0x0C6;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1C;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x11;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 109: 
            
            a[0] = 0x00A;   //ster1         
            a[3] = 0x10;    //ster4 INV druciak
            a[4] = 0x1C;    //ster3 ABS krazek scierny
            a[5] = 0x190;   //delta okrag
            a[7] = 0x10;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 110: 
            
            a[0] = 0x032;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1E;    //ster3 ABS krazek scierny
            a[5] = 0x190;   //delta okrag
            a[7] = 0x0F;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 111: 
            
            a[0] = 0x;   //ster1         
            a[3] = 0x;    //ster4 INV druciak
            a[4] = 0x;    //ster3 ABS krazek scierny
            a[5] = 0x;   //delta okrag
            a[7] = 0x;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 112: 
            
            a[0] = 0x0E2;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1C;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x11;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 113: 
            
            a[0] = 0x0D4;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x19;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x11;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 114: 
            
            a[0] = 0x04A;   //ster1         
            a[3] = 0x10;    //ster4 INV druciak
            a[4] = 0x1D;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x0F;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 115: 
            
            a[0] = 0x076;   //ster1         
            a[3] = 0x12;    //ster4 INV druciak
            a[4] = 0x1F;    //ster3 ABS krazek scierny
            a[5] = 0x19C;   //delta okrag
            a[7] = 0x11;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 116: 
            
            a[0] = 0x092;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x21;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    
    case 117: 
            
            a[0] = 0x11A;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x19;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x11;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    
    case 118: 
            
            a[0] = 0x056;   //ster1         
            a[3] = 0x10;    //ster4 INV druciak
            a[4] = 0x1D;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x11;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 119: 
            
            a[0] = 0x072;   //ster1         
            a[3] = 0x12;    //ster4 INV druciak
            a[4] = 0x1F;    //ster3 ABS krazek scierny
            a[5] = 0x19C;   //delta okrag
            a[7] = 0x11;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 120: 
            
            a[0] = 0x0D0;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x21;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 121: 
            
            a[0] = 0x048;   //ster1         
            a[3] = 0x10;    //ster4 INV druciak
            a[4] = 0x1D;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x11;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 122: 
            
            a[0] = 0x09A;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1E;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 123: 
            
            a[0] = 0x046;   //ster1         
            a[3] = 0x10;    //ster4 INV druciak
            a[4] = 0x17;    //ster3 ABS krazek scierny
            a[5] = 0x193;   //delta okrag
            a[7] = 0x13;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    
    case 124: 
            
            a[0] = 0x0E0;   //ster1         
            a[3] = 0x0F;    //ster4 INV druciak
            a[4] = 0x15;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x13;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 125: 
            
            a[0] = 0x038;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1E;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x11;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 126: 
            
            a[0] = 0x0CA;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1E;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 127: 
            
            a[0] = 0x0DE;   //ster1         
            a[3] = 0x10;    //ster4 INV druciak
            a[4] = 0x17;    //ster3 ABS krazek scierny
            a[5] = 0x193;   //delta okrag
            a[7] = 0x13;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 128: 
            
            a[0] = 0x116;   //ster1         
            a[3] = 0x10;    //ster4 INV druciak
            a[4] = 0x18;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x13;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 129: 
            
            a[0] = 0x0E8;   //ster1         
            a[3] = 0x0F;    //ster4 INV druciak
            a[4] = 0x18;    //ster3 ABS krazek scierny
            a[5] = 0x199;   //delta okrag
            a[7] = 0x13;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 130: 
            
            a[0] = 0x0F2;   //ster1         
            a[3] = 0x12;    //ster4 INV druciak
            a[4] = 0x23;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x10;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 131: 
            
            a[0] = 0x108;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1F;    //ster3 ABS krazek scierny
            a[5] = 0x19C;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    
    case 132: 
            
            a[0] = 0x064;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1C;    //ster3 ABS krazek scierny
            a[5] = 0x19C;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    case 133: 
            
            a[0] = 0x088;   //ster1         
            a[3] = 0x0F;    //ster4 INV druciak
            a[4] = 0x18;    //ster3 ABS krazek scierny
            a[5] = 0x199;   //delta okrag
            a[7] = 0x13;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    
    case 134: 
            
            a[0] = 0x10E;   //ster1         
            a[3] = 0x12;    //ster4 INV druciak
            a[4] = 0x23;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x10;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
               ////////////////////////////////////////////////////////////////////////////////////////////////////////
     case 135: 
            
            a[0] = 0x054;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1F;    //ster3 ABS krazek scierny
            a[5] = 0x19C;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
     case 136: 
            
            a[0] = 0x03E;   //ster1         
            a[3] = 0x10;    //ster4 INV druciak
            a[4] = 0x18;    //ster3 ABS krazek scierny
            a[5] = 0x190;   //delta okrag
            a[7] = 0x10;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
     case 137: 
            
            a[0] = 0x00C;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1E;    //ster3 ABS krazek scierny
            a[5] = 0x190;   //delta okrag
            a[7] = 0x0F;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
     case 138: 
            
            a[0] = 0x0DC;   //ster1         
            a[3] = 0x10;    //ster4 INV druciak
            a[4] = 0x1B;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x11;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
     case 139: 
            
            a[0] = 0x058;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x19;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
     case 140: 
            
            a[0] = 0x03C;   //ster1         
            a[3] = 0x10;    //ster4 INV druciak
            a[4] = 0x17;    //ster3 ABS krazek scierny
            a[5] = 0x190;   //delta okrag
            a[7] = 0x10;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag
            
                
    
    break; 
    
    
     case 141: 
            
            a[0] = 0x00E;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1E;    //ster3 ABS krazek scierny
            a[5] = 0x190;   //delta okrag
            a[7] = 0x0F;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
     case 142: 
            
            a[0] = 0x10A;   //ster1         
            a[3] = 0x10;    //ster4 INV druciak
            a[4] = 0x1B;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x11;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
    
     case 143: 
            
            a[0] = 0x022;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x19;    //ster3 ABS krazek scierny
            a[5] = 0x196;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 0;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
    
    
     case 144: 
            
            a[0] = 0x066;   //ster1         
            a[3] = 0x11;    //ster4 INV druciak
            a[4] = 0x1C;    //ster3 ABS krazek scierny
            a[5] = 0x19C;   //delta okrag
            a[7] = 0x12;    //ster3 INV krazek scierny
            a[9] = 1;     //na minus czy na plus wzgledem uklad liniowy szczotki drucianej   0 - na minus, 1 - na plus rzad 1
            
            a[1] = a[0]+0x001;  //ster2
            a[2] = a[4];        //ster4 ABS druciak    
            a[6] = a[5]+0x001;  //okrag
            a[8] = a[6]+0x001;  //-delta okrag    
    
    break; 
   
    
}
    
//if(predkosc_pion_szczotka == 50)   //zwolnienie predkosci pion     
//       {
//       a[3] = a[3] - 0x05;
//       }

if(tryb_pracy_szczotki_drucianej == 1)
         a[3] = a[3];
         
if(tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3)
         a[3] = a[3]-0x05;
         
//if(predkosc_pion_krazek == 50)   //zwolnienie predkosci pion krazek    
//       {
//       a[7] = a[7] - 0x05;
//       }

a[3] = a[3]-0x06;   //odejmuje 6 bo przesuwalem aby zyskac PORT
a[2] = a[2]-0x06;   //odejmuje 6 bo przesuwalem aby zyskac PORT



if(krazek_scierny_cykl_po_okregu_ilosc == 0 | ruch_haos == 1)
        a[7] = a[7] - 0x05; 

if(srednica_krazka_sciernego == 40)
        a[4] = a[4]+ 0x13; 

                                                     //2
if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 1 & srednica_krazka_sciernego == 30)
    {  
    }

                                                   //2
if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 2 & srednica_krazka_sciernego == 30)
    {
    a[5] = a[5] + 0x10;   //plus 16 dzesietnie
    a[6] = a[5]+0x001;  //okrag
    a[8] = a[6]+0x001;  //-delta okrag  
    }
                                                    //1
if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 3 & srednica_krazka_sciernego == 30)
    {
    a[5] = a[5] + 0x20;   //plus 32 dzesietnie
    a[6] = a[5]+0x001;  //okrag
    a[8] = a[6]+0x001;  //-delta okrag  
    }

                                                    //2
if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 4 & srednica_krazka_sciernego == 30)
    {
    a[5] = a[5] + 0x30;   //plus 48 dzesietnie
    a[6] = a[5]+0x001;  //okrag
    a[8] = a[6]+0x001;  //-delta okrag    
    }

/////////////////////////////////////////////////////////////////////////////////////

if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 1 & srednica_krazka_sciernego == 40)
    {  
    a[5] = a[5] + 0x39;   //plus 66 dzesietnie   ///////////////
    a[6] = a[5]+0x001;  //okrag
    a[8] = a[6]+0x001;  //-delta okrag 
    }

                                                   //2
if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 2 & srednica_krazka_sciernego == 40)
    {
    a[5] = a[5] + 0x42;   //plus 16 dzesietnie
    a[6] = a[5]+0x001;  //okrag
    a[8] = a[6]+0x001;  //-delta okrag  
    }
                                                    //1
if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 3 & srednica_krazka_sciernego == 40)
    {
    a[5] = a[5] + 0x4B;   //plus 32 dzesietnie
    a[6] = a[5]+0x001;  //okrag
    a[8] = a[6]+0x001;  //-delta okrag  
    }

                                                    //2
if(wejscie_krazka_sciernego_w_pow_boczna_cylindra == 4 & srednica_krazka_sciernego == 40)
    {
    a[5] = a[5] + 0x54;   //plus 48 dzesietnie
    a[6] = a[5]+0x001;  //okrag
    a[8] = a[6]+0x001;  //-delta okrag    
    }
     
}

void obsluga_nacisniecia_zatrzymaj()
{
int sg;
sg = 0; 

  if(sek20 > 60)
   {      
   sek20 = 0;
   while(sprawdz_pin2(PORTMM,0x77) == 0)
        {
        wartosc_parametru_panelu(0,0,64);  //start na 0;
        PORTD.7 = 1;
        if(PORTE.2 == 1)
           {
           byla_wloczona_szlifierka_1 = 1;
           PORTE.2 = 0;
           }
        
        if(PORTE.3 == 1)
           {
           byla_wloczona_szlifierka_2 = 1;
           PORTE.3 = 0;
           }
        
         if(PORT_F.bits.b4 == 1)
            {
            byl_wloczony_przedmuch = 1;
            zastopowany_czas_przedmuchu = sek12;
            PORT_F.bits.b4 = 0;  //przedmuch zaciskow    
            PORTF = PORT_F.byte;  
            }
        
          
        komunikat_na_panel("                                                ",adr1,adr2);
        komunikat_na_panel("Zatrzymano - nacisnij START aby wznowic",adr1,adr2);
        komunikat_na_panel("                                                ",adr3,adr4);
        komunikat_na_panel("Zatrzymano - nacisnij START aby wznowic",adr3,adr4);
        
        }
        
    if(PORTD.7 == 1)
        {
        while(sg == 0)
            {
            if(sprawdz_pin2(PORTMM,0x77) == 1) 
                sg = odczytaj_parametr(0,64);              
            
            
            }
        
        komunikat_na_panel("                                                ",adr1,adr2);
        komunikat_na_panel("                                                ",adr3,adr4);
        
        PORTD.7 = 0;
        if(byla_wloczona_szlifierka_1 == 1)
            {
            PORTE.2 = 1;
            byla_wloczona_szlifierka_1 = 0;
            }
        if(byla_wloczona_szlifierka_2 == 1)
            {
            PORTE.3 = 1;
            byla_wloczona_szlifierka_2 = 0;
            }
        if(byl_wloczony_przedmuch == 1)
            {
            PORT_F.bits.b4 = 1;  //przedmuch zaciskow    
            PORTF = PORT_F.byte;  
            sek12 = zastopowany_czas_przedmuchu;
            byl_wloczony_przedmuch = 0;
            }    
        }
    }      
                              
}


void obsluga_otwarcia_klapy_rzad()
{
int sg;
sg = 0; 

if(rzad_obrabiany == 1 & start == 1)
   {      
   while(sprawdz_pin0(PORTMM,0x77) == 1)
        {
        wartosc_parametru_panelu(0,0,64);  //start na 0;
        PORTD.7 = 1;
        if(PORTE.2 == 1)
           {
           byla_wloczona_szlifierka_1 = 1;
           PORTE.2 = 0;
           }
        
        if(PORTE.3 == 1)
           {
           byla_wloczona_szlifierka_2 = 1;
           PORTE.3 = 0;
           }
        
           if(PORT_F.bits.b4 == 1)
            {
            byl_wloczony_przedmuch = 1;
            zastopowany_czas_przedmuchu = sek12;
            PORT_F.bits.b4 = 0;  //przedmuch zaciskow    
            PORTF = PORT_F.byte;  
            }
        
           
        komunikat_na_panel("                                                ",adr1,adr2);
        komunikat_na_panel("Zamknij oslony gorne i nacisnij START",adr1,adr2);
        komunikat_na_panel("                                                ",adr3,adr4);
        komunikat_na_panel("Zamknij oslony gorne i nacisnij START",adr3,adr4);
        
        }
    if(PORTD.7 == 1)
        {
        while(sg == 0)
            {
            if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0) 
                sg = odczytaj_parametr(0,64);              
            
            
            }
        
        komunikat_na_panel("                                                ",adr1,adr2);
        komunikat_na_panel("                                                ",adr3,adr4);
        
        PORTD.7 = 0;
          if(byla_wloczona_szlifierka_1 == 1)
            {
            PORTE.2 = 1;
            byla_wloczona_szlifierka_1 = 0;
            }
        if(byla_wloczona_szlifierka_2 == 1)
            {
            PORTE.3 = 1;
            byla_wloczona_szlifierka_2 = 0;
            }
        if(byl_wloczony_przedmuch == 1)
            {
            PORT_F.bits.b4 = 1;  //przedmuch zaciskow    
            PORTF = PORT_F.byte;  
            sek12 = zastopowany_czas_przedmuchu;
            byl_wloczony_przedmuch = 0;
            }    
        }      
   }                           


if(rzad_obrabiany == 2 & start == 1)
   {      
   while(sprawdz_pin1(PORTMM,0x77) == 1)
        {
        wartosc_parametru_panelu(0,0,64);  //start na 0;
        PORTD.7 = 1;
        if(PORTE.2 == 1)
           {
           byla_wloczona_szlifierka_1 = 1;
           PORTE.2 = 0;
           }
        
        if(PORTE.3 == 1)
           {
           byla_wloczona_szlifierka_2 = 1;
           PORTE.3 = 0;
           }
        
         if(PORT_F.bits.b4 == 1)
            {
            byl_wloczony_przedmuch = 1;
            zastopowany_czas_przedmuchu = sek12;
            PORT_F.bits.b4 = 0;  //przedmuch zaciskow    
            PORTF = PORT_F.byte;  
            }
          
        komunikat_na_panel("                                                ",adr1,adr2);
        komunikat_na_panel("Zamknij oslony gorne i nacisnij START",adr1,adr2);
        komunikat_na_panel("                                                ",adr3,adr4);
        komunikat_na_panel("Zamknij oslony gorne i nacisnij START",adr3,adr4);
        
        }
    if(PORTD.7 == 1)
        {
        while(sg == 0)
            {
            if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0) 
                sg = odczytaj_parametr(0,64);              
            
            
            }
        
        komunikat_na_panel("                                                ",adr1,adr2);
        komunikat_na_panel("                                                ",adr3,adr4);
        
        PORTD.7 = 0;
        if(byla_wloczona_szlifierka_1 == 1)
            {
            PORTE.2 = 1;
            byla_wloczona_szlifierka_1 = 0;
            }
        if(byla_wloczona_szlifierka_2 == 1)
            {
            PORTE.3 = 1;
            byla_wloczona_szlifierka_2 = 0;
            }
        if(byl_wloczony_przedmuch == 1)
            {
            PORT_F.bits.b4 = 1;  //przedmuch zaciskow    
            PORTF = PORT_F.byte;  
            sek12 = zastopowany_czas_przedmuchu;
            byl_wloczony_przedmuch = 0;
            }    
        }      
   }                           





}


void odczyt_parametru_panelu_stala_pamiec(int adres_nieulotny1, int adres_nieulotny2, int dokad_adres1,int dokad_adres2) 
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
putchar(adres_nieulotny1);   //00
putchar(adres_nieulotny2);   //00
putchar(dokad_adres1);   //10
putchar(dokad_adres2);   //10
putchar(0);   //0
putchar(10);   //ile danych
}




void wartosc_parametru_panelu_stala_pamiec(int adres_nieulotny1,int adres_nieulotny2, int skad_adres1, int skad_adres2) 
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
putchar(adres_nieulotny1);   //00
putchar(adres_nieulotny2);   //00
putchar(skad_adres1);   //10
putchar(skad_adres2);   //0
putchar(0);   //0
putchar(10);   //ile danych
}





void wartosci_wstepne_wgrac_tylko_raz(int ktore_wgrac)
{
if(ktore_wgrac == 0)
{
szczotka_druciana_ilosc_cykli = 2;
krazek_scierny_ilosc_cykli = 6;
tryb_pracy_szczotki_drucianej = 1;
krazek_scierny_cykl_po_okregu_ilosc = 0;
czas_pracy_szczotki_drucianej_stala = 150;
czas_pracy_krazka_sciernego_stala = 100;
czas_pracy_szczotki_drucianej_h_17 = 0;
czas_pracy_szczotki_drucianej_h_15 = 0;
czas_pracy_krazka_sciernego_h_34 = 0;
czas_pracy_krazka_sciernego_h_36 = 0;
czas_pracy_krazka_sciernego_h_38 = 0;
czas_pracy_krazka_sciernego_h_41 = 0;
czas_pracy_krazka_sciernego_h_43 = 0;
}


wartosc_parametru_panelu(szczotka_druciana_ilosc_cykli,48,64);
delay_ms(200);
wartosc_parametru_panelu_stala_pamiec(0,0,48,64);                       //proba
//putchar(adres_nieulotny1);   //00
//putchar(adres_nieulotny2);   //00
//putchar(skad_adres1);   //10
//putchar(skad_adres2);   //0
delay_ms(200);
odczyt_parametru_panelu_stala_pamiec(0,0,48,64);
//putchar(adres_nieulotny1);
//putchar(adres_nieulotny2);   //00
//putchar(dokad_adres1);   //10
//putchar(dokad_adres2);   //10
delay_ms(200);


wartosc_parametru_panelu(krazek_scierny_ilosc_cykli,32,144);
wartosc_parametru_panelu_stala_pamiec(0,16,32,144);
delay_ms(200);
odczyt_parametru_panelu_stala_pamiec(0,16,32,144);
delay_ms(200);


wartosc_parametru_panelu(krazek_scierny_cykl_po_okregu_ilosc,48,0);
wartosc_parametru_panelu_stala_pamiec(0,32,48,0);
delay_ms(200);
odczyt_parametru_panelu_stala_pamiec(0,32,48,0);
delay_ms(200);


wartosc_parametru_panelu(tryb_pracy_szczotki_drucianej,0,112);
wartosc_parametru_panelu_stala_pamiec(0,48,0,112);
delay_ms(200);
odczyt_parametru_panelu_stala_pamiec(0,48,0,112);
delay_ms(200);



wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_stala,16,112);
wartosc_parametru_panelu_stala_pamiec(0,64,16,112);
delay_ms(200);
odczyt_parametru_panelu_stala_pamiec(0,64,16,112);
delay_ms(200);


wartosc_parametru_panelu(czas_pracy_krazka_sciernego_stala,32,16);
wartosc_parametru_panelu_stala_pamiec(0,80,32,16);
delay_ms(200);
odczyt_parametru_panelu_stala_pamiec(0,80,32,16);
delay_ms(200);


if(srednica_wew_korpusu_cyklowa == 0 | srednica_wew_korpusu_cyklowa == 38 | srednica_wew_korpusu_cyklowa == 41 | srednica_wew_korpusu_cyklowa == 43)
{
wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_h_17,0,144);
wartosc_parametru_panelu_stala_pamiec(0,96,0,144);
delay_ms(200);
odczyt_parametru_panelu_stala_pamiec(0,96,0,144);
delay_ms(200);
}



if(srednica_wew_korpusu_cyklowa == 0 | srednica_wew_korpusu_cyklowa == 34 | srednica_wew_korpusu_cyklowa == 36)
{
wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_h_15,16,128);
wartosc_parametru_panelu_stala_pamiec(16,32,16,128);
delay_ms(200);
odczyt_parametru_panelu_stala_pamiec(16,32,16,128);
delay_ms(200);
}


if(srednica_wew_korpusu_cyklowa == 0 | srednica_wew_korpusu_cyklowa == 34)
{
wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_34,96,48);
wartosc_parametru_panelu_stala_pamiec(0,112,96,48);
delay_ms(200);
odczyt_parametru_panelu_stala_pamiec(0,112,96,48);
delay_ms(200);
}

if(srednica_wew_korpusu_cyklowa == 0 | srednica_wew_korpusu_cyklowa == 36)
{
wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_36,96,64);
wartosc_parametru_panelu_stala_pamiec(0,128,96,64);
delay_ms(200);
odczyt_parametru_panelu_stala_pamiec(0,128,96,64);
delay_ms(200);
}

if(srednica_wew_korpusu_cyklowa == 0 | srednica_wew_korpusu_cyklowa == 38)
{
wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_38,96,80);
wartosc_parametru_panelu_stala_pamiec(0,144,96,80);
delay_ms(200);
odczyt_parametru_panelu_stala_pamiec(0,144,96,80);
delay_ms(200);
}

if(srednica_wew_korpusu_cyklowa == 0 | srednica_wew_korpusu_cyklowa == 41)
{
wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_41,96,96);
wartosc_parametru_panelu_stala_pamiec(16,0,96,96);
delay_ms(200);
odczyt_parametru_panelu_stala_pamiec(16,0,96,96);
delay_ms(200);
}

if(srednica_wew_korpusu_cyklowa == 0 | srednica_wew_korpusu_cyklowa == 43)
{
wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_43,96,112);
wartosc_parametru_panelu_stala_pamiec(16,16,96,112);
delay_ms(200);
odczyt_parametru_panelu_stala_pamiec(16,16,96,112);
delay_ms(200);
}



}



void zapis_probny_test()
{
int dupa_dupa;

dupa_dupa = odczytaj_parametr(128,144);             //uruchomienie cyklu przez zapis

if(dupa_dupa == 1)
    {
     
     
     
     srednica_wew_korpusu_cyklowa = 38;
                                                
                             tryb_pracy_szczotki_drucianej = odczytaj_parametr(0,112);
                             szczotka_druciana_ilosc_cykli = odczytaj_parametr(48,64); 
                               krazek_scierny_ilosc_cykli = odczytaj_parametr(32,144);        
                                        krazek_scierny_cykl_po_okregu_ilosc = odczytaj_parametr(48,0);
                                        czas_pracy_szczotki_drucianej_stala = odczytaj_parametr(16,112);
                                        czas_pracy_krazka_sciernego_stala = odczytaj_parametr(32,16);
    
                            
                             if(srednica_wew_korpusu_cyklowa == 34 | srednica_wew_korpusu_cyklowa == 36)
                                 czas_pracy_szczotki_drucianej_h_15++;
                                
                             if(srednica_wew_korpusu_cyklowa == 38 | srednica_wew_korpusu_cyklowa == 41 | srednica_wew_korpusu_cyklowa == 43)
                                 czas_pracy_szczotki_drucianej_h_17++;
         
                            
                            if(srednica_wew_korpusu_cyklowa == 34)
                                czas_pracy_krazka_sciernego_h_34++;
                            if(srednica_wew_korpusu_cyklowa == 36)
                                czas_pracy_krazka_sciernego_h_36++;
                            if(srednica_wew_korpusu_cyklowa == 38)
                                czas_pracy_krazka_sciernego_h_38++;
                            if(srednica_wew_korpusu_cyklowa == 41)
                                czas_pracy_krazka_sciernego_h_41++;
                            if(srednica_wew_korpusu_cyklowa == 43)
                                czas_pracy_krazka_sciernego_h_43++;
                                
                            wartosci_wstepne_wgrac_tylko_raz(1); //to trwa 3s 
                            
                                
                                //wartosc wstpena panelu
                              wartosc_parametru_panelu(0,128,144);
    
    } 


}


void wartosci_wstepne_panelu()
{

delay_ms(200);
odczyt_parametru_panelu_stala_pamiec(0,0,48,64);                                                      
delay_ms(200);
//////////////////////////////////////////////////wartosc_parametru_panelu(szczotka_druciana_ilosc_cykli,48,64);  


odczyt_parametru_panelu_stala_pamiec(0,16,32,144);
delay_ms(200);
/////////////////////////////////////////////////wartosc_parametru_panelu(krazek_scierny_ilosc_cykli,32,144);  
                                                        //3000
odczyt_parametru_panelu_stala_pamiec(0,32,48,0);
delay_ms(200);
/////////////////////////////////////////////////////////wartosc_parametru_panelu(krazek_scierny_cykl_po_okregu_ilosc,48,0);  
                                                //2050

/////////////////////////
delay_ms(200);
odczyt_parametru_panelu_stala_pamiec(0,64,16,112);
/////////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_stala,16,112);

delay_ms(200);
odczyt_parametru_panelu_stala_pamiec(0,80,32,16);
/////////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(czas_pracy_krazka_sciernego_stala,32,16);

delay_ms(200);
odczyt_parametru_panelu_stala_pamiec(0,96,0,144);
/////////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_h_17,0,144);

delay_ms(200);
odczyt_parametru_panelu_stala_pamiec(16,32,16,128);
/////////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_h_15,16,128);

delay_ms(200);
odczyt_parametru_panelu_stala_pamiec(0,112,96,48);
/////////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_34,96,48);

delay_ms(200);
odczyt_parametru_panelu_stala_pamiec(0,128,96,64);
/////////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_36,96,64);

delay_ms(200);
odczyt_parametru_panelu_stala_pamiec(0,144,96,80);
/////////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_38,96,80);

delay_ms(200);
odczyt_parametru_panelu_stala_pamiec(16,0,96,96);
/////////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_41,96,96);

delay_ms(200);
odczyt_parametru_panelu_stala_pamiec(16,16,96,112);
/////////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_43,96,112);

delay_ms(200);
odczyt_parametru_panelu_stala_pamiec(0,48,0,112);
delay_ms(200);
//////////////////////////////////////////////////////////////////////////wartosc_parametru_panelu(tryb_pracy_szczotki_drucianej,0,112);


//////////////////////////
wartosc_parametru_panelu(predkosc_pion_szczotka,32,80);
                                                //2060
wartosc_parametru_panelu(predkosc_pion_krazek,32,96);
                                                                       //3010
wartosc_parametru_panelu(wejscie_krazka_sciernego_w_pow_boczna_cylindra,48,16);
                                                                     //2070
wartosc_parametru_panelu(predkosc_ruchow_po_okregu_krazek_scierny,32,112);
wartosc_parametru_panelu(40,48,112);  //srednica krazka wstepnie 
wartosc_parametru_panelu(145,48,128);   //to do manualnego wczytywania zacisku, ma byc 145
wartosc_parametru_panelu(1,128,64);   //to do statystyki, zeby zawsze bylo 1



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
      
      if((guzik2 + guzik4 + guzik6 + guzik8) == 4 & (guzik2 == 1 & guzik4 == 1 & guzik6 == 1 & guzik8 == 1))
                   {
                   
                   putchar(90);  //5A
                   putchar(165); //A5
                   putchar(4);//04  //zmiana obrazu
                   putchar(128);  //80
                   putchar(3);    //03
                   putchar(0);   //
                   putchar(65);   //0
                   
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







void wypozycjonuj_napedy_minimalistyczna()
{
//sek20


while(start == 0)
    {
    komunikat_na_panel("                                                ",adr1,adr2);
    komunikat_na_panel("Nacisnij START aby wypozycjonowac napedy",adr1,adr2);
    komunikat_na_panel("                                                ",adr3,adr4);
    komunikat_na_panel("Nacisnij START aby wypozycjonowac napedy",adr3,adr4);
    delay_ms(1000);
    start = odczytaj_parametr(0,64);
    }


while(sprawdz_pin0(PORTMM,0x77) == 1 | sprawdz_pin1(PORTMM,0x77) == 1)
    {
    komunikat_na_panel("                                                ",adr1,adr2);
    komunikat_na_panel("Zamknij oslony gorne",adr1,adr2);
    komunikat_na_panel("                                                ",adr3,adr4);
    komunikat_na_panel("Zamknij oslony gorne",adr3,adr4);
    } 


PORTB.4 = 1;   //setupy piony
delay_ms(1000);
PORTB.4 = 0;   //setupy piony
PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie



while(sprawdz_pin3(PORTKK,0x75) == 1 | sprawdz_pin7(PORTKK,0x75) == 1)
      {
      if(sprawdz_pin0(PORTMM,0x77) == 1 | sprawdz_pin1(PORTMM,0x77) == 1)
        while(1)
            {
            PORTD.7 = 1;
            PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
            
            PORTB.4 = 0;   //setupy piony
            PORTD.2 = 0;   //setup wspolny
            
            komunikat_na_panel("                                                ",adr1,adr2);
            komunikat_na_panel("Otwarcie oslon w trakcie pozycjonowania",adr1,adr2);
            komunikat_na_panel("                                                ",adr3,adr4);
            komunikat_na_panel("Wylacz i wlacz maszyne",adr3,adr4);
            
            wartosc_parametru_panelu(0,0,64);  //start na 0;
            }
      
      
      if(sprawdz_pin2(PORTMM,0x77) == 0)
        while(1)
            {
            PORTD.7 = 1;
            PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
            
            PORTB.4 = 0;   //setupy piony
            PORTD.2 = 0;   //setup wspolny
            
            komunikat_na_panel("                                                ",adr1,adr2);
            komunikat_na_panel("Zatrzymanie w trakcie pozycjonowania",adr1,adr2);
            komunikat_na_panel("                                                ",adr3,adr4);
            komunikat_na_panel("Wylacz i wlacz maszyne",adr3,adr4);
            
            wartosc_parametru_panelu(0,0,64);  //start na 0;
            }
      
       
      komunikat_na_panel("                                                ",adr1,adr2);
      komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr1,adr2);
      komunikat_na_panel("                                                ",adr3,adr4);
      komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr3,adr4);
      delay_ms(1000);
      
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
      
      
      if(sprawdz_pin6(PORTMM,0x77) == 1 |
         sprawdz_pin7(PORTMM,0x77) == 1)
            {
            PORTD.7 = 1;
            if(sprawdz_pin6(PORTMM,0x77) == 1)
                {
                komunikat_na_panel("                                                ",adr1,adr2);
                komunikat_na_panel("Alarm Sterownik 4",adr1,adr2); 
                delay_ms(1000);
                }
            if(sprawdz_pin7(PORTMM,0x77) == 1)
                {
                komunikat_na_panel("                                                ",adr1,adr2);
                komunikat_na_panel("Alarm Sterownik 3",adr1,adr2); 
                delay_ms(1000);
                }    
            }
      
      
      
      
      
      
      
      
      }

PORTB.4 = 0;   //setupy piony
PORTD.2 = 1;   //setup poziomy
delay_ms(1000);
PORTD.2 = 0;   //setup wspolny
sek20 = 0;

while((sprawdz_pin3(PORTJJ,0x79) == 1 | sprawdz_pin3(PORTLL,0x71) == 1) & sek20 < 3662)
      {
      
      if(sprawdz_pin0(PORTMM,0x77) == 1 | sprawdz_pin1(PORTMM,0x77) == 1)
        while(1)
            {
            PORTD.7 = 1;
            PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
            komunikat_na_panel("                                                ",adr1,adr2);
            komunikat_na_panel("Otwarcie oslon w trakcie pozycjonowania",adr1,adr2);
            komunikat_na_panel("                                                ",adr3,adr4);
            komunikat_na_panel("Wylacz i wlacz maszyne",adr3,adr4);
            
            PORTB.4 = 0;   //setupy piony
            PORTD.2 = 0;   //setup wspolny
            
            wartosc_parametru_panelu(0,0,64);  //start na 0;
            }
      
      
      if(sprawdz_pin2(PORTMM,0x77) == 0)
        while(1)
            {
            PORTD.7 = 1;
            PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
            
            PORTB.4 = 0;   //setupy piony
            PORTD.2 = 0;   //setup wspolny
            
            komunikat_na_panel("                                                ",adr1,adr2);
            komunikat_na_panel("Zatrzymanie w trakcie pozycjonowania",adr1,adr2);
            komunikat_na_panel("                                                ",adr3,adr4);
            komunikat_na_panel("Wylacz i wlacz maszyne",adr3,adr4);
            
            wartosc_parametru_panelu(0,0,64);  //start na 0;
            }
      
      komunikat_na_panel("                                                ",adr1,adr2);
      komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr1,adr2);
      komunikat_na_panel("                                                ",adr3,adr4);
      komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr3,adr4);
      delay_ms(1000);
      
      if(sprawdz_pin3(PORTJJ,0x79) == 0)
            {
            if(sprawdz_pin3(PORTLL,0x71) == 1 & & PORTD.2 == 0)
                 PORTD.2 = 1;   //setup wspolny      ////////////PROBA 22.11.2019
            komunikat_na_panel("                                                ",adr1,adr2);
            komunikat_na_panel("Sterownik 1 - wypozycjonowalem",adr1,adr2);
            delay_ms(1000);
            PORTD.2 = 0;
            }
      if(sprawdz_pin3(PORTLL,0x71) == 0)      
            {
            if(sprawdz_pin3(PORTJJ,0x79) == 1 & PORTD.2 == 0)
                 PORTD.2 = 1;   //setup wspolny      ////////////PROBA 22.11.2019
            komunikat_na_panel("                                                ",adr3,adr4);
            komunikat_na_panel("Sterownik 2 - wypozycjonowalem",adr3,adr4);
            delay_ms(1000);
            PORTD.2 = 0;   //setup wspolny      ////////////PROBA 22.11.2019
            }
      
       //if(sprawdz_pin7(PORTMM,0x77) == 1)
       //     PORTD.7 = 1;
       
      if(sprawdz_pin5(PORTJJ,0x79) == 1 |
         sprawdz_pin5(PORTLL,0x71) == 1)
            {
            PORTD.7 = 1;
            if(sprawdz_pin5(PORTJJ,0x79) == 1)
                {
                komunikat_na_panel("                                                ",adr1,adr2);
                komunikat_na_panel("Alarm Sterownik 1",adr1,adr2); 
                delay_ms(1000);
                }
            if(sprawdz_pin5(PORTLL,0x71) == 1)    
                {
                komunikat_na_panel("                                                ",adr1,adr2);
                komunikat_na_panel("Alarm Sterownik 2",adr1,adr2); 
                delay_ms(1000);
                }
                
            }
       
      //sprawdz_pin6(PORTMM,0x77) ALARM STEROWNIK4      
//sprawdz_pin7(PORTMM,0x77) ALARM STEROWNIK3  
      //sprawdz_pin5(PORTJJ,0x79)  ALARM  STEROWNIK1
       //sprawdz_pin5(PORTLL,0x71)  ALARM  STEROWNIK2
       
              
            
      }  







//to jest to pozycjonowanie powtornie na wszelki wypadek jak ju� osie Y dojecha�y na miejsca 
PORTD.2 = 0;   //setup wspolny
delay_ms(500);
PORTD.2 = 1;   //setup poziomy
delay_ms(1000);
PORTD.2 = 0;   //setup wspolny

while(sprawdz_pin3(PORTJJ,0x79) == 1 | sprawdz_pin3(PORTLL,0x71) == 1)
      {
      
      if(sprawdz_pin0(PORTMM,0x77) == 1 | sprawdz_pin1(PORTMM,0x77) == 1)
        while(1)
            {
            PORTD.7 = 1;
            PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
            komunikat_na_panel("                                                ",adr1,adr2);
            komunikat_na_panel("Otwarcie oslon w trakcie pozycjonowania",adr1,adr2);
            komunikat_na_panel("                                                ",adr3,adr4);
            komunikat_na_panel("Wylacz i wlacz maszyne",adr3,adr4);
            
            PORTB.4 = 0;   //setupy piony
            PORTD.2 = 0;   //setup wspolny
            
            wartosc_parametru_panelu(0,0,64);  //start na 0;
            }
      
      
      if(sprawdz_pin2(PORTMM,0x77) == 0)
        while(1)
            {
            PORTD.7 = 1;
            PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
            
            PORTB.4 = 0;   //setupy piony
            PORTD.2 = 0;   //setup wspolny
            
            komunikat_na_panel("                                                ",adr1,adr2);
            komunikat_na_panel("Zatrzymanie w trakcie pozycjonowania",adr1,adr2);
            komunikat_na_panel("                                                ",adr3,adr4);
            komunikat_na_panel("Wylacz i wlacz maszyne",adr3,adr4);
            
            wartosc_parametru_panelu(0,0,64);  //start na 0;
            }
      
      //komunikat_na_panel("                                                ",adr1,adr2);
      //komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr1,adr2);
      //komunikat_na_panel("                                                ",adr3,adr4);
      //komunikat_na_panel("Pozycjonuje uklady liniowe XYZ",adr3,adr4);
      //delay_ms(1000);
      
      if(sprawdz_pin3(PORTJJ,0x79) == 0)
            {
            komunikat_na_panel("                                                ",adr1,adr2);
            komunikat_na_panel("Sterownik 1 - wypozycjonowalem",adr1,adr2);
            }
      if(sprawdz_pin3(PORTLL,0x71) == 0)      
            {
            komunikat_na_panel("                                                ",adr3,adr4);
            komunikat_na_panel("Sterownik 2 - wypozycjonowalem",adr3,adr4);
            }
      
       //if(sprawdz_pin7(PORTMM,0x77) == 1)
       //     PORTD.7 = 1;
       
      if(sprawdz_pin5(PORTJJ,0x79) == 1 |
         sprawdz_pin5(PORTLL,0x71) == 1)
            {
            PORTD.7 = 1;
            if(sprawdz_pin5(PORTJJ,0x79) == 1)
                {
                komunikat_na_panel("                                                ",adr1,adr2);
                komunikat_na_panel("Alarm Sterownik 1",adr1,adr2); 
                delay_ms(1000);
                }
            if(sprawdz_pin5(PORTLL,0x71) == 1)    
                {
                komunikat_na_panel("                                                ",adr1,adr2);
                komunikat_na_panel("Alarm Sterownik 2",adr1,adr2); 
                delay_ms(1000);
                }
                
            }
       
      //sprawdz_pin6(PORTMM,0x77) ALARM STEROWNIK4      
//sprawdz_pin7(PORTMM,0x77) ALARM STEROWNIK3  
      //sprawdz_pin5(PORTJJ,0x79)  ALARM  STEROWNIK1
       //sprawdz_pin5(PORTLL,0x71)  ALARM  STEROWNIK2
       
              
            
      }  












komunikat_na_panel("                                                ",adr1,adr2);
komunikat_na_panel("Wypozycjonowano uklady liniowe XYZ",adr1,adr2);
komunikat_na_panel("                                                ",adr3,adr4);
komunikat_na_panel("Wypozycjonowano uklady liniowe XYZ",adr3,adr4);

PORTD.2 = 0;   //setup wspolny
PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
delay_ms(1000);
wartosc_parametru_panelu(0,0,64);  //start na 0;
start = 0;

}


void przerzucanie_dociskow()
{

if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
  {
   if(sprawdz_pin6(PORTLL,0x71) == 0 & sprawdz_pin7(PORTLL,0x71) == 0 & czekaj_az_puszcze == 0)
           {
           czekaj_az_puszcze = 1;
           //PORTB.6 = 1;
           } 
       if(sprawdz_pin6(PORTLL,0x71) == 1 & sprawdz_pin7(PORTLL,0x71) == 1 & czekaj_az_puszcze == 1)  
           {
           czekaj_az_puszcze = 2;
           //PORTB.6 = 0;
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
}

void ostateczny_wybor_zacisku()
{
int rzad;

  if(sek11 > 60) //co 1s sekunde sprawdzam   //jak co 40 to sie wywala
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
        rzad = odczyt_wybranego_zacisku();
        //sek10 = 0;
        sek11 = 0;    //nowe
        odczytalem_zacisk++;
        
        //if(rzad == 1)
        //    wartosc_parametru_panelu(2,32,128);    //tego nie chca
        //if(rzad == 2)
        //    wartosc_parametru_panelu(1,32,128);
        
        }                                     //& sek10 > 1                //3s po odczytaniu dopiero sprawdzam port
if((odczytalem_zacisk == il_prob_odczytu + 1))        //183
        {
        
        if(rzad == 1)
            wartosc_parametru_panelu(0,0,96);  //wykonano zaciskow rzad1
        
        if(rzad == 2 & start == 0)
            wartosc_parametru_panelu(0,0,16);  //wykonano zaciskow rzad2
        
        if(rzad == 2 & start == 1)
            zaaktualizuj_ilosc_rzad2 = 1;
        
        
        odczytalem_zacisk = 0;
        if(start == 1)
            odczytalem_w_trakcie_czyszczenia_drugiego_rzedu = 1;
        }
}



int sterownik_1_praca(int PORT)
{
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

if(sprawdz_pin5(PORTJJ,0x79) == 1)     //if alarn
    {
    PORTD.7 = 1;
    PORTE.2 = 0;
    PORTE.3 = 0;  //szlifierki stop
    PORT_F.bits.b4 = 0;  //przedmuch zaciskow    
    PORTF = PORT_F.byte;
    
    while(1)
        {
        komunikat_na_panel("                                                ",adr1,adr2);
        komunikat_na_panel("Kolizja XY ukladu krazka",adr1,adr2);
        komunikat_na_panel("                                                ",adr3,adr4);
        komunikat_na_panel("Kolizja XY ukladu krazka",adr3,adr4);
        }
    
    }

if(start == 1)
    {
    obsluga_otwarcia_klapy_rzad();
    obsluga_nacisniecia_zatrzymaj();
    }
switch(cykl_sterownik_1)
        {
        case 0:
        
            sek1 = 0;
            PORT_STER1.byte = PORT;
            PORTA.0 = PORT_STER1.bits.b0;
            PORTA.1 = PORT_STER1.bits.b1;
            PORTA.2 = PORT_STER1.bits.b2;
            PORTA.3 = PORT_STER1.bits.b3;
            PORTA.4 = PORT_STER1.bits.b4;
            PORTA.5 = PORT_STER1.bits.b5;
            PORTA.6 = PORT_STER1.bits.b6;
            PORTA.7 = PORT_STER1.bits.b7;
            
            if(PORT > 0x0FF)
                PORTD.4 = 1;

           
            
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


int sterownik_2_praca(int PORT)
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

 if(sprawdz_pin5(PORTLL,0x71) == 1)
    {
    PORTD.7 = 1;   
    PORTE.2 = 0;
    PORTE.3 = 0;  //szlifierki stop
    PORT_F.bits.b4 = 0;  //przedmuch zaciskow    
    PORTF = PORT_F.byte;
    
    while(1)
        {
        komunikat_na_panel("                                                ",adr1,adr2);
        komunikat_na_panel("Kolizja XY ukladu szczotki",adr1,adr2);
        komunikat_na_panel("                                                ",adr3,adr4);
        komunikat_na_panel("Kolizja XY ukladu szczotki",adr3,adr4);
        }
    
    }
if(start == 1)
    {
    obsluga_otwarcia_klapy_rzad();
    obsluga_nacisniecia_zatrzymaj();
    }
switch(cykl_sterownik_2)
        {
        case 0:
        
            sek3 = 0;
            PORT_STER2.byte = PORT;
            PORTC.0 = PORT_STER2.bits.b0;
            PORTC.1 = PORT_STER2.bits.b1;
            PORTC.2 = PORT_STER2.bits.b2;
            PORTC.3 = PORT_STER2.bits.b3;
            PORTC.4 = PORT_STER2.bits.b4;
            PORTC.5 = PORT_STER2.bits.b5;
            PORTC.6 = PORT_STER2.bits.b6;
            PORTC.7 = PORT_STER2.bits.b7; 
            if(PORT > 0x0FF)
                PORTD.5 = 1;

            
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





                     
int sterownik_3_praca(int PORT)
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

if(sprawdz_pin7(PORTMM,0x77) == 1)
     {
     PORTD.7 = 1;
     PORTE.2 = 0;
     PORTE.3 = 0;  //szlifierki stop
     PORT_F.bits.b4 = 0;  //przedmuch zaciskow    
     PORTF = PORT_F.byte;
    
     while(1)
        {
        komunikat_na_panel("                                                ",adr1,adr2);
        komunikat_na_panel("Kolizja krazka - wylacz i wlacz maszyne",adr1,adr2);
        komunikat_na_panel("                                                ",adr3,adr4);
        komunikat_na_panel("Kolizja krazka - wylacz i wlacz maszyne",adr3,adr4);
        }
     }
if(start == 1)
    {
    obsluga_otwarcia_klapy_rzad();
    obsluga_nacisniecia_zatrzymaj();
    
    }
switch(cykl_sterownik_3)
        {
        case 0:
            
            PORT_STER3.byte = PORT;
            PORT_F.bits.b0 = PORT_STER3.bits.b0;      
            PORT_F.bits.b1 = PORT_STER3.bits.b1;
            PORT_F.bits.b2 = PORT_STER3.bits.b2;
            PORT_F.bits.b3 = PORT_STER3.bits.b3;
            PORT_F.bits.b7 = PORT_STER3.bits.b4;
            PORTF = PORT_F.byte;      
            PORTB.7 = PORT_STER3.bits.b5;
            
         
            
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
int sterownik_4_praca(int PORT,int p)
{


//PORTB.0   IN0  STEROWNIK4   
//PORTB.1   IN1  STEROWNIK4
//PORTB.2   IN2  STEROWNIK4
//PORTB.3   IN3  STEROWNIK4
//PORTE.4  IN4  STEROWNIK4 



//PORTB.4   SETUP  STEROWNIK4
//PORTB.5   DRIVE  STEROWNIK4

//sprawdz_pin4(PORTKK,0x75)  B7 BUSY    LECCP STEROWNIK4
//sprawdz_pin7(PORTKK,0x75)  B10 INP    LECP6 STEROWNIK4 

if(sprawdz_pin6(PORTMM,0x77) == 1)
    {
    PORTD.7 = 1;
    PORTE.2 = 0;
    PORTE.3 = 0;
    PORT_F.bits.b4 = 0;  //przedmuch zaciskow    
    PORTF = PORT_F.byte;
    
    while(1)
        {
        komunikat_na_panel("                                                ",adr1,adr2);
        komunikat_na_panel("Kolizja szcz. drucianej - wylacz i wlacz maszyne",adr1,adr2);
        komunikat_na_panel("                                                ",adr3,adr4);
        komunikat_na_panel("Kolizja szcz. drucianej - wylacz i wlacz maszyne",adr3,adr4);
        }
    
    }
if(start == 1)
    {
    obsluga_otwarcia_klapy_rzad();
    obsluga_nacisniecia_zatrzymaj();
    }
switch(cykl_sterownik_4)
        {
        case 0:
        
            PORT_STER4.byte = PORT;
            PORTB.0 = PORT_STER4.bits.b0;      
            PORTB.1 = PORT_STER4.bits.b1;
            PORTB.2 = PORT_STER4.bits.b2;
            PORTB.3 = PORT_STER4.bits.b3;
            PORTE.4 = PORT_STER4.bits.b4;
            
            
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
                  
                  PORTB.0 = 0;      
                  PORTB.1 = 0;
                  PORTB.2 = 0;
                  PORTB.3 = 0;
                  PORTE.4 = 0;
                  
                  
                  sek4 = 0;
                  cykl_sterownik_4 = 3;
                  }
    
        break;
    
        case 3:
    
               if(sprawdz_pin7(PORTKK,0x75) == 0)  //czy INP
                  {
                  //if(p == 1)
                  //  PORTE.2 = 1;  //wylaczam do testu    
                  
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


void test_geometryczny()
{
int cykl_testu,d;
int ff[12];
int i;
d = 0;
cykl_testu = 0;

for(i=0;i<11;i++)
     ff[i]=0;


manualny_wybor_zacisku = 145;
manualny_wybor_zacisku = odczytaj_parametr(48,128);

if(manualny_wybor_zacisku != 145)
    {
    macierz_zaciskow[1] = manualny_wybor_zacisku; 
    macierz_zaciskow[2] = manualny_wybor_zacisku;
    }

                                                                   //swiatlo czer       //swiatlo zolte & PORT_F.bits.b6 == 0
if(test_geometryczny_rzad_1 == 1 & test_geometryczny_rzad_2 == 0 & PORTD.7 == 0   &
    il_zaciskow_rzad_1 > 1 & macierz_zaciskow[1]!=0 & sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0) 
    {
    while(test_geometryczny_rzad_1 == 1)
        {
        switch(cykl_testu)
            {
             case 0:
    
               wybor_linijek_sterownikow(1);
               PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
               cykl_sterownik_1 = 0;
               cykl_sterownik_2 = 0;
               cykl_sterownik_3 = 0;
               cykl_sterownik_4 = 0;
               wybor_linijek_sterownikow(1);
               cykl_testu = 1;
    
    
    
            break;                             
                                 
            case 1:
    
            //na sam dol zjezdzamy pionami
                if(cykl_sterownik_3 < 5)
                    cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
                if(cykl_sterownik_4 < 5)
                    cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
                 
                if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
                                        {
                                        cykl_sterownik_3 = 0;
                                        cykl_sterownik_4 = 0;
                                        cykl_testu = 2;
                                        }
                
                
    
            break;
            
                                  
            case 2:
            
                                if(cykl_sterownik_1 < 5)
                                    cykl_sterownik_1 = sterownik_1_praca(0x000);
                                 if(cykl_sterownik_2 < 5)                                //ster 1 pod pin pozycjonujacy 
                                    cykl_sterownik_2 = sterownik_2_praca(0x008);       //ster 2 ucieczka do zera (druciak)
                                    
                                    if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
                                        {
                                        cykl_sterownik_1 = 0;
                                        cykl_sterownik_2 = 0;
                                        cykl_sterownik_3 = 0;
                                        cykl_sterownik_4 = 0;
                                        cykl_testu = 3;
                                       
                                        }
    
            break;                
            
             
            case 3:
            
                                if(cykl_sterownik_1 < 5)
                                    cykl_sterownik_1 = sterownik_1_praca(a[0]); //ster 1 pod srodek zacisku 
                                                                
                                    if(cykl_sterownik_1 == 5)
                                        {
                                        cykl_sterownik_1 = 0;
                                        cykl_sterownik_2 = 0;
                                        cykl_sterownik_3 = 0;
                                        cykl_sterownik_4 = 0;
                                        cykl_testu = 4;
                                        }
    
            break;              
            
            case 4:
            
                                   if(cykl_sterownik_3 < 5)
                                        cykl_sterownik_3 = sterownik_3_praca(a[4]);  //abs
                                        
                                   if(cykl_sterownik_3 == 5)
                                        {
                                        cykl_sterownik_1 = 0;
                                        cykl_sterownik_2 = 0;
                                        cykl_sterownik_3 = 0;
                                        cykl_sterownik_4 = 0;
                                        cykl_testu = 5;
                                        }
            
            break;
            
            case 5:
                                   if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
                                   {
                                     d = odczytaj_parametr(48,80);  
                                        if(d == 0)
                                            cykl_testu = 666;
                                        
                                        if(d == 2 & ff[2] == 0)
                                            {
                                            cykl_testu = 6;                                
                                            ff[d]=1;
                                            }    
                                        if(d == 3 & ff[2] == 1 & ff[3] == 0)
                                            {
                                            cykl_testu = 6;                                
                                            ff[d]=1;
                                            }
                                        if(d == 4 & ff[3] == 1 & ff[4] == 0)
                                            {
                                            cykl_testu = 6;                                
                                            ff[d]=1;
                                            }
                                        if(d == 5 & ff[4] == 1 & ff[5] == 0)
                                            {
                                            cykl_testu = 6;                                
                                            ff[d]=1;
                                            }
                                        if(d == 6 & ff[5] == 1 & ff[6] == 0)
                                            {
                                            cykl_testu = 6;                                
                                            ff[d]=1;
                                            }
                                        if(d == 7 & ff[6] == 1 & ff[7] == 0)
                                            {
                                            cykl_testu = 6;                                
                                            ff[d]=1;
                                            }
                                        if(d == 8 & ff[7] == 1 & ff[8] == 0)
                                            {
                                            cykl_testu = 6;                                
                                            ff[d]=1;
                                            }
                                        if(d == 9 & ff[8] == 1 & ff[9] == 0)
                                            {
                                            cykl_testu = 6;                                
                                            ff[d]=1;
                                            }
                                        if(d == 10 & ff[9] == 1 & ff[10] == 0)
                                            {
                                            cykl_testu = 6;                                
                                            ff[d]=1;
                                            }
                                    }    
                                             
            break;
            
            case 6:
                                     if(cykl_sterownik_3 < 5)
                                            cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
                                        if(cykl_sterownik_3 == 5)
                                            {
                                            cykl_sterownik_1 = 0;
                                            cykl_sterownik_2 = 0;
                                            cykl_sterownik_3 = 0;
                                            cykl_sterownik_4 = 0;
                                            cykl_testu = 7;
                                            }
            
            break;
            
            case 7:
            
                                    if(cykl_sterownik_1 < 5)
                                        cykl_sterownik_1 = sterownik_1_praca(0x003);     //pod nastepny dolek
                                    
                                    if(cykl_sterownik_1 == 5)
                                        {
                                        cykl_sterownik_1 = 0;
                                        cykl_sterownik_2 = 0;
                                        cykl_sterownik_3 = 0;
                                        cykl_sterownik_4 = 0;
                                        cykl_testu = 4;
                                        }
                                    
                                    
            break;
            
            
            
            
            
            
            
            case 666:
                                     
                                        if(cykl_sterownik_3 < 5)
                                            cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
                                        if(cykl_sterownik_3 == 5)
                                            {
                                            cykl_sterownik_3 = 0;
                                            cykl_sterownik_4 = 0;
                                            cykl_testu = 100;
                                            test_geometryczny_rzad_1 = 0;
                                            PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
                                            }
            
            break;
            
            
            
            }
        
        }
    }



                                                                   //swiatlo czer       //swiatlo zolte & PORT_F.bits.b6 == 0
if(test_geometryczny_rzad_1 == 0 & test_geometryczny_rzad_2 == 1 & PORTD.7 == 0  &
    il_zaciskow_rzad_2 > 0 & macierz_zaciskow[2]!=0 & sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0) 
    {
    while(test_geometryczny_rzad_2 == 1)
        {
        switch(cykl_testu)
            {
             case 0:
               
               wybor_linijek_sterownikow(2);
               PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
               cykl_sterownik_1 = 0;
               cykl_sterownik_2 = 0;
               cykl_sterownik_3 = 0;
               cykl_sterownik_4 = 0;
               wybor_linijek_sterownikow(2);
               cykl_testu = 1;
    
    
    
            break;                             
                                 
            case 1:
    
            //na sam dol zjezdzamy pionami
                if(cykl_sterownik_3 < 5)
                    cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
                if(cykl_sterownik_4 < 5)
                    cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
                 
                if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
                                        {
                                        cykl_sterownik_3 = 0;
                                        cykl_sterownik_4 = 0;
                                        cykl_testu = 2;
                                        }
                
                
    
            break;
            
                                  
            case 2:
            
                                if(cykl_sterownik_1 < 5)
                                    cykl_sterownik_1 = sterownik_1_praca(0x001);
                                 if(cykl_sterownik_2 < 5)                                //ster 1 pod pin pozycjonujacy rzad 2 
                                    cykl_sterownik_2 = sterownik_2_praca(0x009);       //ster 2 ucieczka dla II rzedu (druciak)
                                    
                                    if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
                                        {
                                        cykl_sterownik_1 = 0;
                                        cykl_sterownik_2 = 0;
                                        cykl_sterownik_3 = 0;
                                        cykl_sterownik_4 = 0;
                                        cykl_testu = 3;
                                       
                                        }
    
            break;                
            
            
            case 3:
            
                                if(cykl_sterownik_1 < 5)
                                    cykl_sterownik_1 = sterownik_1_praca(a[1]); //ster 1 pod srodek zacisku 
                                                                
                                    if(cykl_sterownik_1 == 5)
                                        {
                                        cykl_sterownik_1 = 0;
                                        cykl_sterownik_2 = 0;
                                        cykl_sterownik_3 = 0;
                                        cykl_sterownik_4 = 0;
                                        cykl_testu = 4;
                                        }
    
            break;              
            
            case 4:
            
                                   if(cykl_sterownik_3 < 5)
                                        cykl_sterownik_3 = sterownik_3_praca(a[4]);  //abs
                                        
                                   if(cykl_sterownik_3 == 5)
                                        {
                                        cykl_sterownik_1 = 0;
                                        cykl_sterownik_2 = 0;
                                        cykl_sterownik_3 = 0;
                                        cykl_sterownik_4 = 0;
                                        cykl_testu = 5;
                                        }
            
            break;
            
            case 5:
                                     if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
                                     {
                                     d = odczytaj_parametr(48,96); 
                                        if(d == 0)
                                            cykl_testu = 666;
                                     
            
            
            
                                        if(d == 2 & ff[2] == 0)
                                            {
                                            cykl_testu = 6;                                
                                            ff[d]=1;
                                            }    
                                        if(d == 3 & ff[2] == 1 & ff[3] == 0)
                                            {
                                            cykl_testu = 6;                                
                                            ff[d]=1;
                                            }
                                        if(d == 4 & ff[3] == 1 & ff[4] == 0)
                                            {
                                            cykl_testu = 6;                                
                                            ff[d]=1;
                                            }
                                        if(d == 5 & ff[4] == 1 & ff[5] == 0)
                                            {
                                            cykl_testu = 6;                                
                                            ff[d]=1;
                                            }
                                        if(d == 6 & ff[5] == 1 & ff[6] == 0)
                                            {
                                            cykl_testu = 6;                                
                                            ff[d]=1;
                                            }
                                        if(d == 7 & ff[6] == 1 & ff[7] == 0)
                                            {
                                            cykl_testu = 6;                                
                                            ff[d]=1;
                                            }
                                        if(d == 8 & ff[7] == 1 & ff[8] == 0)
                                            {
                                            cykl_testu = 6;                                
                                            ff[d]=1;
                                            }
                                        if(d == 9 & ff[8] == 1 & ff[9] == 0)
                                            {
                                            cykl_testu = 6;                                
                                            ff[d]=1;
                                            }
                                        if(d == 10 & ff[9] == 1 & ff[10] == 0)
                                            {
                                            cykl_testu = 6;                                
                                            ff[d]=1;
                                            }
                                        
                                      }       
            break;
            
            case 6:
                                     if(cykl_sterownik_3 < 5)
                                            cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
                                        if(cykl_sterownik_3 == 5)
                                            {
                                            cykl_sterownik_1 = 0;
                                            cykl_sterownik_2 = 0;
                                            cykl_sterownik_3 = 0;
                                            cykl_sterownik_4 = 0;
                                            cykl_testu = 7;
                                            }
            
            break;
            
            case 7:
            
                                    if(cykl_sterownik_1 < 5)
                                        cykl_sterownik_1 = sterownik_1_praca(0x003);     //pod nastepny dolek
                                    
                                    if(cykl_sterownik_1 == 5)
                                        {
                                        cykl_sterownik_1 = 0;
                                        cykl_sterownik_2 = 0;
                                        cykl_sterownik_3 = 0;
                                        cykl_sterownik_4 = 0;
                                        cykl_testu = 4;
                                        }
                                    
                                    
            break;
            
            
            
            case 666:
                                     
                                        if(cykl_sterownik_3 < 5)
                                            cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
                                        if(cykl_sterownik_3 == 5)
                                            {
                                            cykl_sterownik_3 = 0;
                                            cykl_sterownik_4 = 0;
                                            cykl_testu = 100;
                                            PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
                                            test_geometryczny_rzad_2 = 0;
                                            }
            
            break;
            
            
            
            }
        
        }
    }




}





void kontrola_zoltego_swiatla()
{

 
if(czas_pracy_szczotki_drucianej_h_17 >= czas_pracy_szczotki_drucianej_stala)
     {
     PORT_F.bits.b6 = 1;      
     PORTF = PORT_F.byte;
     komunikat_na_panel("                                                ",80,0);
     komunikat_na_panel("Wymien szczotke druciana 17-stke",80,0);
     }
     
if(czas_pracy_szczotki_drucianej_h_15 >= czas_pracy_szczotki_drucianej_stala)
     {
     PORT_F.bits.b6 = 1;      
     PORTF = PORT_F.byte;
     komunikat_na_panel("                                                ",80,0);
     komunikat_na_panel("Wymien szczotke druciana 15-stke",16,128);
     }

if(czas_pracy_krazka_sciernego_h_34 >= czas_pracy_krazka_sciernego_stala)
     {
     PORT_F.bits.b6 = 1;      
     PORTF = PORT_F.byte;
     komunikat_na_panel("                                                ",64,0);
     komunikat_na_panel("Wymien krazek scierny do korpusu o srednicy 34",64,0);
     }

if(czas_pracy_krazka_sciernego_h_36 >= czas_pracy_krazka_sciernego_stala)
     {
     PORT_F.bits.b6 = 1;      
     PORTF = PORT_F.byte;
     komunikat_na_panel("                                                ",64,0);
     komunikat_na_panel("Wymien krazek scierny do korpusu o srednicy 36",64,0);
     }

if(czas_pracy_krazka_sciernego_h_38 >= czas_pracy_krazka_sciernego_stala)
     {
     PORT_F.bits.b6 = 1;      
     PORTF = PORT_F.byte;
     komunikat_na_panel("                                                ",64,0);
     komunikat_na_panel("Wymien krazek scierny do korpusu o srednicy 38",64,0);
     }

if(czas_pracy_krazka_sciernego_h_41 >= czas_pracy_krazka_sciernego_stala)
     {
     PORT_F.bits.b6 = 1;      
     PORTF = PORT_F.byte;
     komunikat_na_panel("                                                ",64,0);
     komunikat_na_panel("Wymien krazek scierny do korpusu o srednicy 41",64,0);
     }

if(czas_pracy_krazka_sciernego_h_43 >= czas_pracy_krazka_sciernego_stala)
     {
     PORT_F.bits.b6 = 1;      
     PORTF = PORT_F.byte;
     komunikat_na_panel("                                                ",64,0);
     komunikat_na_panel("Wymien krazek scierny do korpusu o srednicy 43",64,0);
     }



}

void wymiana_szczotki_i_krazka()
{
int g,e,f,d,cykl_wymiany;
cykl_wymiany = 0; 
                      //30 //20

if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
{
g = odczytaj_parametr(48,32);  //szczotka druciana
                    //30  //30
f = odczytaj_parametr(48,48);  //krazek scierny
}

while(g == 1)
    {
    switch(cykl_wymiany)
    {
    case 0:
    
               cykl_sterownik_1 = 0;
               cykl_sterownik_2 = 0;
               cykl_sterownik_3 = 0;
               cykl_sterownik_4 = 0;
               PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
               cykl_wymiany = 1;
    
    
    
    break;                             
                                 
    case 1:
    
            //na sam dol zjezdzamy pionami
                if(cykl_sterownik_3 < 5)
                    cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
                if(cykl_sterownik_4 < 5)
                    cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
                 
                if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
                
                            {
                                        cykl_sterownik_3 = 0;
                                        cykl_sterownik_4 = 0;
                                        cykl_wymiany = 2;
                                        }
                
                
    
    break;
    
    
                                 
    case 2:
            
                                if(cykl_sterownik_1 < 5)
                                    cykl_sterownik_1 = sterownik_1_praca(0x1F9);
                                 if(cykl_sterownik_2 < 5)                                //ster 1 do 0
                                    cykl_sterownik_2 = sterownik_2_praca(0x1F9);       //ster 2 pod pin pozy rzad 1
                                    
                                    if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
                                        {
                                        cykl_sterownik_1 = 0;
                                        cykl_sterownik_2 = 0;
                                        cykl_sterownik_3 = 0;
                                        cykl_sterownik_4 = 0;
                                         cykl_wymiany = 3;
                                       
                                        }
    
    break;                             
                                 
   
                                   
    case 3:
    
            //na sam dol zjezdzamy pionami
                if(cykl_sterownik_3 < 5)
                    cykl_sterownik_3 = sterownik_3_praca(0x02);  //do pozycji wymiany
                if(cykl_sterownik_4 < 5)
                    cykl_sterownik_4 = sterownik_4_praca(0x02,0);  //do pozycji wymiany
                 
                if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
                
                            {
                                        cykl_sterownik_3 = 0;
                                        cykl_sterownik_4 = 0;
                                        d = odczytaj_parametr(48,32);   
                                        
                                        switch (d)
                                        {
                                        case 0:
                                             
                                             if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
                                                {
                                                cykl_wymiany = 4;
                                                PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
                                                }
                                             //jednak nie wymianiamy
                                                
                                        break;
                                        
                                        case 1:
                                             cykl_wymiany = 3;
                                             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
                                             //czekam z decyzja - w trakcie wymiany   
                                        break;
                                        
                                        case 2:
                                             
                                             
                                            
                                             PORT_F.bits.b6 = 0;   //zgas lampke      
                                             PORTF = PORT_F.byte;
                                             
                                             if(srednica_wew_korpusu == 34 | srednica_wew_korpusu == 36)
                                             {
                                             czas_pracy_szczotki_drucianej_h_15 = 0;
                                             wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_h_15,16,128);
                                             wartosc_parametru_panelu_stala_pamiec(16,32,16,128);
                                             delay_ms(200);
                                             odczyt_parametru_panelu_stala_pamiec(16,32,16,128);
                                             delay_ms(200);
                                             }
                                             
                                             if(srednica_wew_korpusu == 38 | srednica_wew_korpusu == 41 | srednica_wew_korpusu == 43)
                                             {
                                             czas_pracy_szczotki_drucianej_h_17 = 0;
                                             wartosc_parametru_panelu(czas_pracy_szczotki_drucianej_h_17,0,144);
                                             wartosc_parametru_panelu_stala_pamiec(0,96,0,144);
                                             delay_ms(200);
                                             odczyt_parametru_panelu_stala_pamiec(0,96,0,144);
                                             delay_ms(200);
                                             }
                                             
                                             komunikat_na_panel("                                                ",80,0);
                                             
                                             if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
                                                {
                                                cykl_wymiany = 4;
                                                PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
                                                }
                                             //wymianymy
                                        break;
                                        }
                            }
                                          
                                        
                                        
                
                
    
    break;
    
   case 4:
                                
                      //na sam dol zjezdzamy pionami
                if(cykl_sterownik_3 < 5)
                    cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
                if(cykl_sterownik_4 < 5)
                    cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
                 
                if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
                                        {
                                        cykl_sterownik_1 = 0;
                                        cykl_sterownik_2 = 0;
                                        cykl_sterownik_3 = 0;
                                        cykl_sterownik_4 = 0;
                                        wartosc_parametru_panelu(0,48,32);
                                        PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
                                        cykl_wymiany = 5;
                                        g = 0;
                                        }
   
   break;

                            
    }//switch
    
   }//while 


while(f == 1)
    {
    switch(cykl_wymiany)
    {
    case 0:
    
               cykl_sterownik_1 = 0;
               cykl_sterownik_2 = 0;
               cykl_sterownik_3 = 0;
               cykl_sterownik_4 = 0;
               PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
               cykl_wymiany = 1;
    
    
    
    break;                             
                                 
    case 1:
    
            //na sam dol zjezdzamy pionami
                if(cykl_sterownik_3 < 5)
                    cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
                if(cykl_sterownik_4 < 5)
                    cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
                 
                if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
                
                            {
                                        cykl_sterownik_3 = 0;
                                        cykl_sterownik_4 = 0;
                                        cykl_wymiany = 2;
                                        }
                
                
    
    break;
    
    
                                 
    case 2:
            
                                if(cykl_sterownik_1 < 5)
                                    cykl_sterownik_1 = sterownik_1_praca(0x1F9);
                                 if(cykl_sterownik_2 < 5)                                //ster 1 do 0
                                    cykl_sterownik_2 = sterownik_2_praca(0x1F9);       //ster 2 pod pin pozy rzad 1
                                    
                                    if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
                                        {
                                        cykl_sterownik_1 = 0;
                                        cykl_sterownik_2 = 0;
                                        cykl_sterownik_3 = 0;
                                        cykl_sterownik_4 = 0;
                                         cykl_wymiany = 3;
                                       
                                        }
    
    break;                             
                                 
   
                                   
    case 3:
    
            //na sam dol zjezdzamy pionami
                if(cykl_sterownik_3 < 5)
                    cykl_sterownik_3 = sterownik_3_praca(0x02);  //do pozycji wymiany
                if(cykl_sterownik_4 < 5)
                    cykl_sterownik_4 = sterownik_4_praca(0x02,0);  //do pozycji wymiany
                 
                if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
                
                            {
                                        cykl_sterownik_3 = 0;
                                        cykl_sterownik_4 = 0;
                                        e = odczytaj_parametr(48,48);   
                                        
                                        switch (e)
                                        {
                                        case 0:
                                             
                                             if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
                                             {
                                             cykl_wymiany = 4;
                                             PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
                                             }
                                             //jednak nie wymianiamy
                                                
                                        break;
                                        
                                        case 1:
                                             PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
                                             cykl_wymiany = 3;
                                             //czekam z decyzja - w trakcie wymiany   
                                        break;
                                        
                                        case 2:
                                             
                                            
                                             
                                             PORT_F.bits.b6 = 0;   //zgas lampke      
                                             PORTF = PORT_F.byte;
                                             
                                             if(srednica_wew_korpusu == 34)
                                             {
                                             czas_pracy_krazka_sciernego_h_34 = 0;
                                             wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_34,96,48);
                                             wartosc_parametru_panelu_stala_pamiec(0,112,96,48);
                                             delay_ms(200);
                                             odczyt_parametru_panelu_stala_pamiec(0,112,96,48);
                                             delay_ms(200);
                                             }

                                             if(srednica_wew_korpusu == 36)
                                             {
                                             czas_pracy_krazka_sciernego_h_36 = 0;
                                             wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_36,96,64);
                                             wartosc_parametru_panelu_stala_pamiec(0,128,96,64);
                                             delay_ms(200);
                                             odczyt_parametru_panelu_stala_pamiec(0,128,96,64);
                                             delay_ms(200);
                                             }

                                             if(srednica_wew_korpusu == 38)
                                             {
                                             czas_pracy_krazka_sciernego_h_38 = 0;
                                             wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_38,96,80);
                                             wartosc_parametru_panelu_stala_pamiec(0,144,96,80);
                                             delay_ms(200);
                                             odczyt_parametru_panelu_stala_pamiec(0,144,96,80);
                                             delay_ms(200);
                                             }

                                            if(srednica_wew_korpusu == 41)
                                            {
                                            czas_pracy_krazka_sciernego_h_41 = 0;
                                            wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_41,96,96);
                                            wartosc_parametru_panelu_stala_pamiec(16,0,96,96);
                                            delay_ms(200);
                                            odczyt_parametru_panelu_stala_pamiec(16,0,96,96);
                                            delay_ms(200);
                                            }

                                            if(srednica_wew_korpusu == 43)
                                            {
                                            czas_pracy_krazka_sciernego_h_43 = 0;
                                            wartosc_parametru_panelu(czas_pracy_krazka_sciernego_h_43,96,112);
                                            wartosc_parametru_panelu_stala_pamiec(16,16,96,112);
                                            delay_ms(200);
                                            odczyt_parametru_panelu_stala_pamiec(16,16,96,112);
                                            delay_ms(200);
                                            }
                                             
                           
                                             komunikat_na_panel("                                                ",64,0);
                                             if(sprawdz_pin0(PORTMM,0x77) == 0 & sprawdz_pin1(PORTMM,0x77) == 0)
                                                     {
                                                     PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
                                                     cykl_wymiany = 4;
                                                     }
                                             //wymianymy
                                        break;
                                        }
                            }
                                          
                                        
                                        
                
                
    
    break;
    
   case 4:
                                
                      //na sam dol zjezdzamy pionami
                if(cykl_sterownik_3 < 5)
                    cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
                if(cykl_sterownik_4 < 5)
                    cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
                 
                if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5)
                
                            {
                                        cykl_sterownik_1 = 0;
                                        cykl_sterownik_2 = 0;
                                        cykl_sterownik_3 = 0;
                                        cykl_sterownik_4 = 0;
                                        cykl_wymiany = 5;
                                        wartosc_parametru_panelu(0,48,48);
                                        PORTB.6 = 0;  //przedmuchy teraz ciagle jak jedzie
                                        f = 0;
                                        }
   
   break;

                            
    }//switch
    
   }//while 








}


void przypadek887()
{
if(sek12 > czas_przedmuchu)
                        {
                        PORT_F.bits.b4 = 0;  //przedmuch zaciskow    
                        PORTF = PORT_F.byte;  
                        }
            
                    
                     if(rzad_obrabiany == 2)
                        ostateczny_wybor_zacisku();
                    
                    if(koniec_rzedu_10 == 1)         
                        cykl_sterownik_4 = 5;
                    
                    
                    if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu_ilosc > 0 & wykonalem_komplet_okregow == 0)  //mini ruch
                          cykl_sterownik_1 = sterownik_1_praca(a[5]);
                    
                    if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 0)
                        {
                        cykl_sterownik_1 = 0;
                        wykonalem_komplet_okregow = 1;
                        }
                    
                    
                    if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
                          cykl_sterownik_1 = sterownik_1_praca(a[6]);
                      
                    if(cykl_sterownik_1 == 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
                        {
                        cykl_sterownik_1 = 0;
                        krazek_scierny_cykl_po_okregu++;
                        }
                        
                    if(krazek_scierny_cykl_po_okregu == krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
                        {
                        cykl_sterownik_1 = 0;
                        wykonalem_komplet_okregow = 2;
                        }
                       
                                                                                          //mini ruch powrotny do okregu, zeby nie szorowal
                    if(cykl_sterownik_1 < 5 & wykonalem_komplet_okregow == 2)
                         cykl_sterownik_1 = sterownik_1_praca(a[8]);                       
                    
                    
                    if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 2)
                        {
                        cykl_sterownik_1 = 0;
                        wykonalem_komplet_okregow = 3;
                        }
                    
                    
                    
                    
                    
                    
                    
                                                              //to nowy war, ostatni dzien w borg
                    if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze)
                         cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc  
                       
                    if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0)
                        {
                        if(koniec_rzedu_10 == 0)
                            cykl_sterownik_4 = 0;
                        if(abs_ster4 == 0)
                            {
                            szczotka_druc_cykl++;
                            abs_ster4 = 1;
                            }
                        else
                            {
                            abs_ster4 = 0;
                            sek13 = 0;
                            }
                        }
                     
                    if(cykl_sterownik_3 < 5 & abs_ster3 == 0 &  powrot_przedwczesny_krazek_scierny == 0)
                         cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV
                         
                    
                    if(cykl_sterownik_3 == 5 & krazek_scierny_cykl < krazek_scierny_ilosc_cykli & powrot_przedwczesny_krazek_scierny == 0)
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
                        cykl_sterownik_3 = sterownik_3_praca(a[4]);  //ABS          //krazek scierny do gory
                    
                    if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0)
                        cykl_sterownik_4 = sterownik_4_praca(0x03,1);  //INV          //druciak do gory   
                   
                   
                   
                   ///////////////////////////////////////////////powrot przedwczesny krazek scierny
                    
                  if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli & wykonalem_komplet_okregow == 3)
                       {
                       cykl_sterownik_3 = 0;
                       powrot_przedwczesny_krazek_scierny = 1;
                       }
                  if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)      
                       cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
                  
                  if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
                       {
                       powrot_przedwczesny_krazek_scierny = 0;
                       PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
                       }
                   //////////////////////////////////////////////     
                   
                   
                   
                   ///////////////////////////////////////////////powrot przedwczesny druciak
                    
                  if(cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & krazek_scierny_cykl != krazek_scierny_ilosc_cykli)
                       {
                       PORTE.2 = 0;  //wylacz szlifierke
                       cykl_sterownik_4 = 0;
                       powrot_przedwczesny_druciak = 1;
                       }
                  if(powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)      
                       cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
                  
                  if(cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
                       {
                       powrot_przedwczesny_druciak = 0;
                       PORTE.2 = 0;  //wylacz szlifierke
                       }
                   //////////////////////////////////////////////     
                           
                    if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
                       krazek_scierny_cykl == krazek_scierny_ilosc_cykli &
                       cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5 &
                       powrot_przedwczesny_krazek_scierny == 0 & powrot_przedwczesny_druciak == 0 &  wykonalem_komplet_okregow == 3)                                
                        {
                        powrot_przedwczesny_krazek_scierny = 0;
                        powrot_przedwczesny_druciak = 0;
                        cykl_sterownik_1 = 0;
                        cykl_sterownik_2 = 0;
                        cykl_sterownik_3 = 0;
                        cykl_sterownik_4 = 0;
                        szczotka_druc_cykl = 0;
                        krazek_scierny_cykl = 0;
                        krazek_scierny_cykl_po_okregu = 0;
                        wykonalem_komplet_okregow = 0;
                        //PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz    
                        //PORTF = PORT_F.byte;
                        PORTE.2 = 0;  //wylacz szlifierke
                        cykl_glowny = 9;
                        }
}



void przypadek888()       
{  
          
                 if(sek12 > czas_przedmuchu)
                        {
                        PORT_F.bits.b4 = 0;  //przedmuch zaciskow    
                        PORTF = PORT_F.byte;  
                        }
            
                    
                     if(rzad_obrabiany == 2)
                        ostateczny_wybor_zacisku();
                    
                    if(koniec_rzedu_10 == 1)         
                        cykl_sterownik_4 = 5;
                    
                    
                    if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu_ilosc > 0 & wykonalem_komplet_okregow == 0)  //mini ruch
                          cykl_sterownik_1 = sterownik_1_praca(a[5]);
                    
                    if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 0)
                        {
                        cykl_sterownik_1 = 0;
                        wykonalem_komplet_okregow = 1;
                        }
                    
                    
                    if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
                          cykl_sterownik_1 = sterownik_1_praca(a[6]);
                      
                    if(cykl_sterownik_1 == 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
                        {
                        cykl_sterownik_1 = 0;
                        krazek_scierny_cykl_po_okregu++;
                        }
                        
                    if(krazek_scierny_cykl_po_okregu == krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
                        {
                        cykl_sterownik_1 = 0;
                        wykonalem_komplet_okregow = 2;
                        }
                       
                                                                                          //mini ruch powrotny do okregu, zeby nie szorowal
                    if(cykl_sterownik_1 < 5 & wykonalem_komplet_okregow == 2)
                         cykl_sterownik_1 = sterownik_1_praca(a[8]);                       
                    
                    
                    if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 2)
                        {
                        cykl_sterownik_1 = 0;
                        wykonalem_komplet_okregow = 3;
                        }
                    
                    
                    
                    
                    
                    
                    
                                                              //to nowy war, ostatni dzien w borg
                    if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze)
                         cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc  
                       
                    if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0)
                        {
                        if(koniec_rzedu_10 == 0)
                            cykl_sterownik_4 = 0;
                        if(abs_ster4 == 0)
                            {
                             if(tryb_pracy_szczotki_drucianej == 2)
                                PORTE.2 = 0;  //wylacz szlifierke
                            szczotka_druc_cykl++;
                            abs_ster4 = 1;
                            if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)  ////////24.04.2019
                                cykl_sterownik_4 = 5;
                            }
                        else
                            {
                            PORTE.2 = 1;  //wlacz szlifierke
                            abs_ster4 = 0;
                            sek13 = 0;
                            }
                        }
                     
                    if(cykl_sterownik_3 < 5 & abs_ster3 == 0 &  powrot_przedwczesny_krazek_scierny == 0)
                         cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV
                         
                    
                    if(cykl_sterownik_3 == 5 & krazek_scierny_cykl < krazek_scierny_ilosc_cykli & powrot_przedwczesny_krazek_scierny == 0)
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
                        cykl_sterownik_3 = sterownik_3_praca(a[4]);  //ABS          //krazek scierny do gory
                    
                       if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0)
                        cykl_sterownik_4 = sterownik_4_praca(a[2],1);  //ABS          //druciak na sama gore
                   
                   ///////////////////////////////////////////////powrot przedwczesny krazek scierny
                    
                  if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli & wykonalem_komplet_okregow == 3)
                       {
                       cykl_sterownik_3 = 0;
                       powrot_przedwczesny_krazek_scierny = 1;
                       }
                  if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)      
                       cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
                  
                  if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
                       {
                       powrot_przedwczesny_krazek_scierny = 0;
                       PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
                       }
                   //////////////////////////////////////////////     
                   
                   
                   
                   ///////////////////////////////////////////////powrot przedwczesny druciak
                    
                  if(cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & krazek_scierny_cykl != krazek_scierny_ilosc_cykli)
                       {
                       PORTE.2 = 0;  //wylacz szlifierke
                       cykl_sterownik_4 = 0;
                       powrot_przedwczesny_druciak = 1;
                       }
                  if(powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)      
                       cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
                  
                  if(cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
                       {
                       powrot_przedwczesny_druciak = 0;
                       PORTE.2 = 0;  //wylacz szlifierke
                       }
                   //////////////////////////////////////////////     
                           
                    if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
                       krazek_scierny_cykl == krazek_scierny_ilosc_cykli &
                       cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5 &
                       powrot_przedwczesny_krazek_scierny == 0 & powrot_przedwczesny_druciak == 0 &  wykonalem_komplet_okregow == 3)                                
                        {
                        powrot_przedwczesny_krazek_scierny = 0;
                        powrot_przedwczesny_druciak = 0;
                        cykl_sterownik_1 = 0;
                        cykl_sterownik_2 = 0;
                        cykl_sterownik_3 = 0;
                        cykl_sterownik_4 = 0;
                        szczotka_druc_cykl = 0;
                        krazek_scierny_cykl = 0;
                        krazek_scierny_cykl_po_okregu = 0;
                        wykonalem_komplet_okregow = 0;
                        //PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz    
                        //PORTF = PORT_F.byte;
                        PORTE.2 = 0;  //wylacz szlifierke
                        cykl_glowny = 9;
                        } 
           
 }



void przypadek997()

{                    
           
           if(sek12 > czas_przedmuchu)
                        {
                        PORT_F.bits.b4 = 0;  //przedmuch zaciskow    
                        PORTF = PORT_F.byte;  
                        }
            
                    
                     if(rzad_obrabiany == 2)
                        ostateczny_wybor_zacisku();
                    
                    if(koniec_rzedu_10 == 1)         
                        cykl_sterownik_4 = 5;
                                                              //to nowy war, ostatni dzien w borg
                    if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze)
                         cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc  
                       
                    if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0)
                        {
                        if(koniec_rzedu_10 == 0)
                            cykl_sterownik_4 = 0;
                        if(abs_ster4 == 0)
                            {
                            szczotka_druc_cykl++;
                            //////////////////////
                            if(statystyka == 1)
                                {
                                wartosc_parametru_panelu(szczotka_druc_cykl,96,128);
                                wartosc_parametru_panelu(cykl_ilosc_zaciskow,128,80);  //pamietac ze zmienna cykl tak naprawde dodaje sie dalej w programie, czyli jak tu bedzie 7 to znaczy ze jestesmy na dolku 8
                                }
                            //////////////////////////
                            abs_ster4 = 1;
                            }
                       else
                            {
                            abs_ster4 = 0;
                            sek13 = 0;
                            }
                        }
                     
                    if(cykl_sterownik_3 < 5 & abs_ster3 == 0 &  powrot_przedwczesny_krazek_scierny == 0)
                         cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV
                         
                    
                    if(cykl_sterownik_3 == 5 & krazek_scierny_cykl < krazek_scierny_ilosc_cykli & powrot_przedwczesny_krazek_scierny == 0)
                        {
                        cykl_sterownik_3 = 0;
                        if(abs_ster3 == 0)
                            {
                            krazek_scierny_cykl++;
                            //////////////////////
                            if(statystyka == 1)
                                wartosc_parametru_panelu(krazek_scierny_cykl,128,96);
                            //////////////////////////
                            abs_ster3 = 1;
                            }
                        else
                            abs_ster3 = 0;
                        }
                    
                    if(cykl_sterownik_3 < 5 & abs_ster3 == 1)
                        cykl_sterownik_3 = sterownik_3_praca(a[4]);  //ABS          //krazek scierny do gory
                                                                                                   
                   
                     if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0)
                        cykl_sterownik_4 = sterownik_4_praca(0x03,1);  //INV          //druciak do gory kawaleczek   
                   
                   ///////////////////////////////////////////////powrot przedwczesny krazek scierny
                    
                  if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli & wykonano_powrot_przedwczesny_krazek_scierny == 0)
                       {
                       cykl_sterownik_3 = 0;
                       powrot_przedwczesny_krazek_scierny = 1;
                       
                       //////////////////////
                       if(statystyka == 1)
                            wartosc_parametru_panelu(powrot_przedwczesny_krazek_scierny,128,112);
                       //////////////////////////
                       sek21 = 0;   //liczenie wlaczenie krazek
                       }
                  if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)      
                       {
                       //if(sek21 > sek21_wylaczenie_szlif)
                       //     PORTE.3 = 0;  //szlifierka 2 (krazek scierny) - wylaczenie bo ocieralo
                             
                       cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
                       }
                  if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
                       {
                       powrot_przedwczesny_krazek_scierny = 0;
                       wykonano_powrot_przedwczesny_krazek_scierny = 1;
                       //////////////////////
                       if(statystyka == 1)
                            wartosc_parametru_panelu(wykonano_powrot_przedwczesny_krazek_scierny,128,128);
                       //////////////////////////
                       PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
                       }
                   //////////////////////////////////////////////     
                   
                   
                   
                   ///////////////////////////////////////////////powrot przedwczesny druciak
                    
                  if(cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & krazek_scierny_cykl != krazek_scierny_ilosc_cykli & wykonano_powrot_przedwczesny_druciak == 0)
                       {
                       PORTE.2 = 0;  //wylacz szlifierke
                       cykl_sterownik_4 = 0;
                       powrot_przedwczesny_druciak = 1;
                       //////////////////////
                       if(statystyka == 1)
                            wartosc_parametru_panelu(powrot_przedwczesny_druciak,96,144);
                       //////////////////////////
                       }
                  if(powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)      
                       cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
                  
                  if(cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
                       {
                       powrot_przedwczesny_druciak = 0;
                       wykonano_powrot_przedwczesny_druciak = 1;
                       ///////////////////////////////
                       if(statystyka == 1)
                            wartosc_parametru_panelu(wykonano_powrot_przedwczesny_druciak,112,0);
                       //////////////////////////////
                       PORTE.2 = 0;  //wylacz szlifierke
                       }
                   ///////////////////////////////////////////////////////////////////////     
                           
                    if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
                       krazek_scierny_cykl == krazek_scierny_ilosc_cykli &
                       cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5 &
                       powrot_przedwczesny_krazek_scierny == 0 & powrot_przedwczesny_druciak == 0)                                
                        {
                        powrot_przedwczesny_krazek_scierny = 0;
                        powrot_przedwczesny_druciak = 0;
                        wykonano_powrot_przedwczesny_krazek_scierny = 0;
                        wykonano_powrot_przedwczesny_druciak = 0;
                        cykl_sterownik_1 = 0;
                        cykl_sterownik_2 = 0;
                        cykl_sterownik_3 = 0;
                        cykl_sterownik_4 = 0;
                        szczotka_druc_cykl = 0;
                        krazek_scierny_cykl = 0;
                        krazek_scierny_cykl_po_okregu = 0;
                        //PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz    
                        //PORTF = PORT_F.byte;
                        PORTE.2 = 0;  //wylacz szlifierke
                        
                        if(statystyka == 1)
                            {
                            wartosc_parametru_panelu(szczotka_druc_cykl,96,128);
                            wartosc_parametru_panelu(krazek_scierny_cykl,128,96);
                            wartosc_parametru_panelu(powrot_przedwczesny_druciak,96,144);
                            wartosc_parametru_panelu(powrot_przedwczesny_krazek_scierny,128,112);
                            wartosc_parametru_panelu(wykonano_powrot_przedwczesny_druciak,112,0);
                            wartosc_parametru_panelu(wykonano_powrot_przedwczesny_krazek_scierny,128,128);
                            }
                        cykl_glowny = 9;
                        sek21 = 0;
                        }

}

void przypadek998()
{

           if(sek12 > czas_przedmuchu)
                        {
                        PORT_F.bits.b4 = 0;  //przedmuch zaciskow    
                        PORTF = PORT_F.byte;  
                        }
            
                    
                     if(rzad_obrabiany == 2)
                        ostateczny_wybor_zacisku();
                    
                    if(koniec_rzedu_10 == 1)         
                        cykl_sterownik_4 = 5;
                                                              
                    if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze)
                         cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc  
                       
                    if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0)
                        {
                        if(koniec_rzedu_10 == 0)
                            cykl_sterownik_4 = 0;
                        if(abs_ster4 == 0)
                            {
                             if(tryb_pracy_szczotki_drucianej == 2)
                                PORTE.2 = 0;  //wylacz szlifierke
                            szczotka_druc_cykl++;
                            abs_ster4 = 1;
                            if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)  ////////24.04.2019
                                cykl_sterownik_4 = 5;
                            }
                        else
                            {
                            PORTE.2 = 1;  //wlacz szlifierke
                            abs_ster4 = 0;
                            sek13 = 0;
                            }
                        }
                     
                    if(cykl_sterownik_3 < 5 & abs_ster3 == 0 &  powrot_przedwczesny_krazek_scierny == 0)
                         cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV
                         
                    
                    if(cykl_sterownik_3 == 5 & krazek_scierny_cykl < krazek_scierny_ilosc_cykli & powrot_przedwczesny_krazek_scierny == 0)
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
                        cykl_sterownik_3 = sterownik_3_praca(a[4]);  //ABS          //krazek scierny do gory
                                                                                                  
                       if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0)
                        cykl_sterownik_4 = sterownik_4_praca(a[2],1);  //ABS          //druciak na sama gore
                   
                   
                   
                   ///////////////////////////////////////////////powrot przedwczesny krazek scierny
                    
                  if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli)
                       {
                       cykl_sterownik_3 = 0;
                       powrot_przedwczesny_krazek_scierny = 1;
                       }
                  if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)      
                       cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
                  
                  if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
                       {
                       powrot_przedwczesny_krazek_scierny = 0;
                       PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
                       }
                   //////////////////////////////////////////////     
                   
                   
                   
                   ///////////////////////////////////////////////powrot przedwczesny druciak
                    
                  if(cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & krazek_scierny_cykl != krazek_scierny_ilosc_cykli)
                       {
                       PORTE.2 = 0;  //wylacz szlifierke
                       cykl_sterownik_4 = 0;
                       powrot_przedwczesny_druciak = 1;
                       }
                  if(powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)      
                       cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
                  
                  if(cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
                       {
                       powrot_przedwczesny_druciak = 0;
                       PORTE.2 = 0;  //wylacz szlifierke
                       }
                   //////////////////////////////////////////////     
                           
                    if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
                       krazek_scierny_cykl == krazek_scierny_ilosc_cykli &
                       cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5 &
                       powrot_przedwczesny_krazek_scierny == 0 & powrot_przedwczesny_druciak == 0)                                
                        {
                        powrot_przedwczesny_krazek_scierny = 0;
                        powrot_przedwczesny_druciak = 0;
                        cykl_sterownik_1 = 0;
                        cykl_sterownik_2 = 0;
                        cykl_sterownik_3 = 0;
                        cykl_sterownik_4 = 0;
                        szczotka_druc_cykl = 0;
                        krazek_scierny_cykl = 0;
                        krazek_scierny_cykl_po_okregu = 0;
                        //PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz    
                        //PORTF = PORT_F.byte;
                        PORTE.2 = 0;  //wylacz szlifierke
                        cykl_glowny = 9;
                        }
}


void przypadek8()

{
            
                    if(sek12 > czas_przedmuchu)
                        {
                        PORT_F.bits.b4 = 0;  //przedmuch zaciskow    
                        PORTF = PORT_F.byte;  
                        }
            
                    
                     if(rzad_obrabiany == 2)
                        ostateczny_wybor_zacisku();
                    
               
                    
                    if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu_ilosc > 0 & wykonalem_komplet_okregow == 0)  //mini ruch
                          cykl_sterownik_1 = sterownik_1_praca(a[5]);
                    if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 0)
                        {
                        cykl_sterownik_1 = 0;
                        wykonalem_komplet_okregow = 1;
                        }
                    
                    
                    if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
                          cykl_sterownik_1 = sterownik_1_praca(a[6]);
                      
                    if(cykl_sterownik_1 == 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
                        {
                        cykl_sterownik_1 = 0;
                        krazek_scierny_cykl_po_okregu++;
                        }
                        
                    if(krazek_scierny_cykl_po_okregu == krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
                        {
                        cykl_sterownik_1 = 0;
                        wykonalem_komplet_okregow = 2;
                        }
                       
                                                                                          //mini ruch powrotny do okregu, zeby nie szorowal
                    if(cykl_sterownik_1 < 5 & wykonalem_komplet_okregow == 2)
                         cykl_sterownik_1 = sterownik_1_praca(a[8]);                       
                    
                    
                    if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 2)
                        {
                        cykl_sterownik_1 = 0;
                        wykonalem_komplet_okregow = 3;
                        }
                    
                    if(cykl_sterownik_3 < 5 & wykonalem_komplet_okregow == 3)
                         cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV         //tu zmienienie INV, �eby szed� w dol
                    
                     if(cykl_sterownik_3 == 5 & wykonalem_komplet_okregow == 3)
                        {
                        krazek_scierny_cykl_po_okregu = 0;
                        krazek_scierny_cykl++;
                        
                        if(krazek_scierny_cykl == krazek_scierny_ilosc_cykli)
                            {
                            wykonalem_komplet_okregow = 4;
                            }
                        else
                            wykonalem_komplet_okregow = 0;
                       
                        cykl_sterownik_1 = 0;
                        cykl_sterownik_3 = 0;
                        }
                     
                  
                    
                    
                    
                    if(koniec_rzedu_10 == 1)         
                        cykl_sterownik_4 = 5;
                                                              //to nowy war, ostatni dzien w borg
                    if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze & koniec_rzedu_10 == 0)
                         cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc  
                       
                    if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0 & koniec_rzedu_10 == 0)
                        {
                        if(koniec_rzedu_10 == 0)
                            cykl_sterownik_4 = 0;
                        if(abs_ster4 == 0)
                            {
                            szczotka_druc_cykl++;
                            abs_ster4 = 1;
                            }
                        else
                            {
                            abs_ster4 = 0;
                            sek13 = 0;
                            }
                        }
                     
                 
                    if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0 & koniec_rzedu_10 == 0)
                        cykl_sterownik_4 = sterownik_4_praca(0x03,1);  //INV          //druciak do gory
                      
                   
                        ///////////////////////////////////////////////powrot przedwczesny krazek scierny
                    
                  if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli)
                       {
                       cykl_sterownik_3 = 0;
                       powrot_przedwczesny_krazek_scierny = 1;
                       }
                  if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)      
                       cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
                  
                  if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
                       {
                       powrot_przedwczesny_krazek_scierny = 0;
                       PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
                       }
                   //////////////////////////////////////////////     
                   
                   
                   
                   ///////////////////////////////////////////////powrot przedwczesny druciak
                    
                  if(koniec_rzedu_10 == 0 & cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & (wykonalem_komplet_okregow !=1 | krazek_scierny_cykl != krazek_scierny_ilosc_cykli))
                       {
                       PORTE.2 = 0;  //wylacz szlifierke
                       cykl_sterownik_4 = 0;
                       powrot_przedwczesny_druciak = 1;
                       }
                  if(koniec_rzedu_10 == 0 & powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)      
                       cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
                  
                  if(koniec_rzedu_10 == 0 & cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
                       powrot_przedwczesny_druciak = 0;
                   //////////////////////////////////////////////     
                           
                    if((wykonalem_komplet_okregow == 4 &
                       szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
                        cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 0 & powrot_przedwczesny_krazek_scierny == 0) | (wykonalem_komplet_okregow == 4 & koniec_rzedu_10 == 1 & powrot_przedwczesny_krazek_scierny == 0) )                                
                        {
                        powrot_przedwczesny_druciak = 0;
                        powrot_przedwczesny_krazek_scierny = 0;
                        cykl_sterownik_1 = 0;
                        cykl_sterownik_2 = 0;
                        cykl_sterownik_3 = 0;
                        cykl_sterownik_4 = 0;
                        szczotka_druc_cykl = 0;
                        krazek_scierny_cykl = 0;
                        krazek_scierny_cykl_po_okregu = 0;
                        //PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz    
                        //PORTF = PORT_F.byte;
                        PORTE.2 = 0;  //wylacz szlifierke
                        cykl_glowny = 9;
                        } 
}                    
                                                                                                //ster 1 - ruch po okregu
                                                                                                //ster 2 - nic
                                                                                                //ster 3 - krazek - gora dol
                                                                                                //ster 4 - druciak - gora dol 
            

void przypadek88()
{
                    
                    if(sek12 > czas_przedmuchu)
                        {
                        PORT_F.bits.b4 = 0;  //przedmuch zaciskow    
                        PORTF = PORT_F.byte;  
                        }
            
                    
                     if(rzad_obrabiany == 2)
                        ostateczny_wybor_zacisku();
                    
               
                    
                    if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu_ilosc > 0 & wykonalem_komplet_okregow == 0)  //mini ruch
                          cykl_sterownik_1 = sterownik_1_praca(a[5]);
                    if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 0)
                        {
                        cykl_sterownik_1 = 0;
                        wykonalem_komplet_okregow = 1;
                        }
                    
                    
                    if(cykl_sterownik_1 < 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
                          cykl_sterownik_1 = sterownik_1_praca(a[6]);
                      
                    if(cykl_sterownik_1 == 5 & krazek_scierny_cykl_po_okregu < krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
                        {
                        cykl_sterownik_1 = 0;
                        krazek_scierny_cykl_po_okregu++;
                        }
                        
                    if(krazek_scierny_cykl_po_okregu == krazek_scierny_cykl_po_okregu_ilosc &  wykonalem_komplet_okregow == 1)
                        {
                        cykl_sterownik_1 = 0;
                        wykonalem_komplet_okregow = 2;
                        }
                       
                                                                                          //mini ruch powrotny do okregu, zeby nie szorowal
                    if(cykl_sterownik_1 < 5 & wykonalem_komplet_okregow == 2)
                         cykl_sterownik_1 = sterownik_1_praca(a[8]);                       
                    
                    
                    if(cykl_sterownik_1 == 5 & wykonalem_komplet_okregow == 2)
                        {
                        cykl_sterownik_1 = 0;
                        wykonalem_komplet_okregow = 3;
                        }
                    
                    if(cykl_sterownik_3 < 5 & wykonalem_komplet_okregow == 3)
                         cykl_sterownik_3 = sterownik_3_praca(a[7]); //INV         //tu zmienienie INV, �eby szed� w dol
                    
                     if(cykl_sterownik_3 == 5 & wykonalem_komplet_okregow == 3)
                        {
                        krazek_scierny_cykl_po_okregu = 0;
                        krazek_scierny_cykl++;
                        
                        if(krazek_scierny_cykl == krazek_scierny_ilosc_cykli)
                            {
                            wykonalem_komplet_okregow = 4;
                            }
                        else
                            wykonalem_komplet_okregow = 0;
                       
                        cykl_sterownik_1 = 0;
                        cykl_sterownik_3 = 0;
                        }
                     
                  
                    
                    
                    
                    if(koniec_rzedu_10 == 1)         
                        cykl_sterownik_4 = 5;
                                                              //to nowy war, ostatni dzien w borg
                    if(cykl_sterownik_4 < 5 & abs_ster4 == 0 & powrot_przedwczesny_druciak == 0 & sek13 > czas_druciaka_na_gorze & koniec_rzedu_10 == 0)
                         cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV               //szczotka druc  
                       
                    if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli & powrot_przedwczesny_druciak == 0 & koniec_rzedu_10 == 0)
                        {
                        if(koniec_rzedu_10 == 0)
                            cykl_sterownik_4 = 0;
                        if(abs_ster4 == 0)
                            {
                             if(tryb_pracy_szczotki_drucianej == 2)
                                PORTE.2 = 0;  //wylacz szlifierke
                            szczotka_druc_cykl++;
                            abs_ster4 = 1;
                            if(szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)  ////////24.04.2019
                                cykl_sterownik_4 = 5;
                            }
                         else
                            {
                            PORTE.2 = 1;  //wlacz szlifierke
                            abs_ster4 = 0;
                            sek13 = 0;
                            }
                        }
                     
                 
                    
                        if(cykl_sterownik_4 < 5 & abs_ster4 == 1 & powrot_przedwczesny_druciak == 0 & koniec_rzedu_10 == 0)
                        cykl_sterownik_4 = sterownik_4_praca(a[2],1);  //ABS          //druciak na sama gore  
                   
                        ///////////////////////////////////////////////powrot przedwczesny krazek scierny
                    
                  if(cykl_sterownik_3 == 5 & krazek_scierny_cykl == krazek_scierny_ilosc_cykli & szczotka_druc_cykl != szczotka_druciana_ilosc_cykli)
                       {
                       cykl_sterownik_3 = 0;
                       powrot_przedwczesny_krazek_scierny = 1;
                       }
                  if(powrot_przedwczesny_krazek_scierny == 1 & cykl_sterownik_3 < 5)      
                       cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
                  
                  if(cykl_sterownik_3 == 5 & powrot_przedwczesny_krazek_scierny == 1)
                       {
                       powrot_przedwczesny_krazek_scierny = 0;
                       PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
                       }
                   //////////////////////////////////////////////     
                   
                   
                   
                   ///////////////////////////////////////////////powrot przedwczesny druciak
                    
                  if(koniec_rzedu_10 == 0 & cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & (wykonalem_komplet_okregow !=1 | krazek_scierny_cykl != krazek_scierny_ilosc_cykli))
                       {
                       PORTE.2 = 0;  //wylacz szlifierke
                       cykl_sterownik_4 = 0;
                       powrot_przedwczesny_druciak = 1;
                       }
                  if(koniec_rzedu_10 == 0 & powrot_przedwczesny_druciak == 1 & cykl_sterownik_4 < 5)      
                       cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej
                  
                  if(koniec_rzedu_10 == 0 & cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 1)
                       powrot_przedwczesny_druciak = 0;
                   //////////////////////////////////////////////     
                           
                    if((wykonalem_komplet_okregow == 4 &
                       szczotka_druc_cykl == szczotka_druciana_ilosc_cykli &
                        cykl_sterownik_4 == 5 & powrot_przedwczesny_druciak == 0 & powrot_przedwczesny_krazek_scierny == 0) | (wykonalem_komplet_okregow == 4 & koniec_rzedu_10 == 1 & powrot_przedwczesny_krazek_scierny == 0) )                                
                        {
                        powrot_przedwczesny_druciak = 0;
                        powrot_przedwczesny_krazek_scierny = 0;
                        cykl_sterownik_1 = 0;
                        cykl_sterownik_2 = 0;
                        cykl_sterownik_3 = 0;
                        cykl_sterownik_4 = 0;
                        szczotka_druc_cykl = 0;
                        krazek_scierny_cykl = 0;
                        krazek_scierny_cykl_po_okregu = 0;
                        //PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz    
                        //PORTF = PORT_F.byte;
                        PORTE.2 = 0;  //wylacz szlifierke
                        cykl_glowny = 9;
                        } 
                    
                                                                                                //ster 1 - ruch po okregu
                                                                                                //ster 2 - nic
                                                                                                //ster 3 - krazek - gora dol
                                                                                                //ster 4 - druciak - gora dol 
            

}


void main(void)
{

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
//UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
//UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
//UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
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

delay_ms(2000); //bo panel sie inicjalizuje
delay_ms(2000); //bo panel sie inicjalizuje
delay_ms(2000); //bo panel sie inicjalizuje
delay_ms(2000); //bo panel sie inicjalizuje

//jak patrze na maszyne to ten po lewej to 1

putchar(90);  //5A
putchar(165); //A5
putchar(3);//03  //znak dzwiekowy ze jestem
putchar(128);  //80
putchar(2);    //02
putchar(16);   //10

il_prob_odczytu = 1;    //100
start = 0;
rzad_obrabiany = 1;
jestem_w_trakcie_czyszczenia_calosci = 0;
wykonalem_rzedow = 0;
cykl_ilosc_zaciskow = 0;
guzik1_przelaczania_zaciskow = 1;
guzik2_przelaczania_zaciskow = 1;
//PORTE.6 = 1;  //aby byl dostep do zaciskow rzad 1
zmienna_przelaczanie_zaciskow = 1;
czas_przedmuchu = 183;
predkosc_pion_szczotka = 100;
predkosc_pion_krazek = 100;
wejscie_krazka_sciernego_w_pow_boczna_cylindra = 1;
predkosc_ruchow_po_okregu_krazek_scierny = 50;
czas_druciaka_na_gorze = 100;  //1 sekundy dla druciaka na gorze aby dolek zrobil git (kiedyS), zmieniam na 3s
czas_zatrzymania_na_dole = 120;
srednica_wew_korpusu_cyklowa = 0;
sek21_wylaczenie_szlif = 200;    //2*63, 63 nie

adr1 = 80;  //rzad 1
adr2 = 0;   //
adr3 = 64;  //rzad 2
adr4 = 0;

//na sekunde
//wartosci_wstepne_wgrac_tylko_raz(0);
//
//while(1)
//{
//}

wartosci_wstepne_panelu();
odpytaj_parametry_panelu();

wypozycjonuj_napedy_minimalistyczna();
sprawdz_cisnienie();

//SPRAWDZAM CO SIE DZIEJE CO CYKL, TO LICZENIE SZCZOTKI I KRAZKA

while (1)
      {         
        //to wylaczam tylko do testow w switniakch, wewnatrz tego wylaczam 4 pierwsze linijki
      odpytaj_parametry_panelu();
      ostateczny_wybor_zacisku();
      przerzucanie_dociskow();
      kontrola_zoltego_swiatla();
      wymiana_szczotki_i_krazka();
      zaktualizuj_parametry_panelu();
      obsluga_trybu_administratora();
      test_geometryczny();
      sprawdz_cisnienie();
      
      //zapis_probny_test();
      
      
        
      while((start == 1 & il_zaciskow_rzad_1 > 1 & il_zaciskow_rzad_2 != 1 & macierz_zaciskow[1]!=0  & (macierz_zaciskow[2]!=0 |  il_zaciskow_rzad_2 == 0)) | jestem_w_trakcie_czyszczenia_calosci == 1)
            {
            switch (cykl_glowny)
            {
            case 0:
                           
                    
                    PORTB.6 = 1;   ////zielona lampka 
                    if(jestem_w_trakcie_czyszczenia_calosci == 0)
                        {
                        //PORTB.6 = 1;  //przedmuchy teraz ciagle jak jedzie
                        
                        srednica_wew_korpusu_cyklowa = srednica_wew_korpusu;
                        
                        wartosc_parametru_panelu(0,0,16);  //wykonano zaciskow rzad1
                        wartosc_parametru_panelu(0,0,96);  //wykonano zaciskow rzad2
                        
                        il_zaciskow_rzad_1 = odczytaj_parametr(0,128); 
                        il_zaciskow_rzad_2 = odczytaj_parametr(0,48);
                        
                        
                        szczotka_druciana_ilosc_cykli = odczytaj_parametr(48,64) - 1;  //wykonano zaciskow rzad1
                                                
                        tryb_pracy_szczotki_drucianej = odczytaj_parametr(0,112);
                        
                        if(tryb_pracy_szczotki_drucianej == 1)
                            szczotka_druciana_ilosc_cykli = 1; //zmieniam bo teraz inny ruch szczotki drucianej, jeden schodek na dole
                        if(tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3)
                            czas_druciaka_na_gorze = 50;
                        
                                                //2090
                        krazek_scierny_ilosc_cykli = odczytaj_parametr(32,144);  //wykonano zaciskow rzad1
                                                    //3000
                        
                        krazek_scierny_cykl_po_okregu_ilosc = odczytaj_parametr(48,0);  //wykonano zaciskow rzad1
                        
                        if(krazek_scierny_cykl_po_okregu_ilosc == 0)
                            {
                            krazek_scierny_ilosc_cykli--; 
                            }
                        
                        predkosc_pion_szczotka = odczytaj_parametr(32,80);
                                                //2060
                        predkosc_pion_krazek = odczytaj_parametr(32,96);
                        
                        wejscie_krazka_sciernego_w_pow_boczna_cylindra = odczytaj_parametr(48,16);
                        
                        predkosc_ruchow_po_okregu_krazek_scierny = odczytaj_parametr(32,112);
                        
                        srednica_krazka_sciernego = odczytaj_parametr(48,112);
                       
                        ruch_haos = odczytaj_parametr(48,144); 
                        
                        statystyka = odczytaj_parametr(128,64);
                        
                        if(il_zaciskow_rzad_2 > 0 & macierz_zaciskow[2]!=0)
                              il_zaciskow_rzad_2 = il_zaciskow_rzad_2;
                        else
                              il_zaciskow_rzad_2 = 0; 
                        
                        wybor_linijek_sterownikow(1);  //rzad 1
                        }
                    
                    jestem_w_trakcie_czyszczenia_calosci = 1;
                    
                    if(rzad_obrabiany == 1)
                    {
                    PORTE.6 = 0;    //przelacz rzad zaciskow - rzad 1
                    if(cykl_sterownik_1 < 5)
                        cykl_sterownik_1 = sterownik_1_praca(0x009);
                    if(cykl_sterownik_2 < 5)                                //ster 1 do 0
                        cykl_sterownik_2 = sterownik_2_praca(0x000);       //ster 2 pod pin pozy rzad 1
                    }
                    
                    if(rzad_obrabiany == 2)
                    {
                    ostateczny_wybor_zacisku();
                    //PORTE.6 = 1;    //przelacz rzad zaciskow - rzad 2 - na razie nie bo nie ma jeszcze oslon
                    
                    if(cykl_sterownik_1 < 5)
                        cykl_sterownik_1 = sterownik_1_praca(0x008);
                    if(cykl_sterownik_2 < 5)                                //ster 1 do 0
                        cykl_sterownik_2 = sterownik_2_praca(0x001);       //ster 2 pod pin pozy rzad 2
                    }
                    
                    
                    if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
                        {
                        
                          if(rzad_obrabiany == 2)
                            {
                            while(PORTE.6 == 0)
                                przerzucanie_dociskow();
                            delay_ms(3000);  //czas na przerzucenie
                            }
                        
                        delay_ms(2000);  //aby zdazyl przelozyc
                        cykl_sterownik_1 = 0;
                        cykl_sterownik_2 = 0;
                        cykl_sterownik_3 = 0;
                        cykl_sterownik_4 = 0;
                        cykl_ilosc_zaciskow = 0;
                        koniec_rzedu_10 = 0;       
                        cykl_glowny = 1;    
                        }
            
            break;
            
            
            
            case 1:
            
                     
                     if(cykl_sterownik_2 < 5 & rzad_obrabiany == 1)
                          {          //ster 1 nic
                          PORTE.7 = 1;   //zacisnij zaciski
                          cykl_sterownik_2 = sterownik_2_praca(a[0]);        //ster 2 pod zacisk
                          }                                                    //ster 4 na pozycje miedzy rzedzami
                     
                     if(cykl_sterownik_2 < 5 & rzad_obrabiany == 2)
                        {
                        //cykl_sterownik_2 = sterownik_2_praca(0x5B,0);
                          PORTE.7 = 1;   //zacisnij zaciski
                          ostateczny_wybor_zacisku();
                          cykl_sterownik_2 = sterownik_2_praca(a[1]);
                         }
                     if(cykl_sterownik_4 < 5 & cykl_sterownik_2 == 5)
                       // cykl_sterownik_4 = sterownik_4_praca(0,0,0,0,0,1);
                        cykl_sterownik_4 = sterownik_4_praca(0x01,0);
                     
                      if(cykl_sterownik_2 == 5 & cykl_sterownik_4 == 5)
                        {
                        cykl_sterownik_1 = 0;
                        cykl_sterownik_2 = 0;
                        cykl_sterownik_4 = 0;
                        szczotka_druc_cykl = 0; 
                        cykl_glowny = 2;     
                        }   
                        
                         
            break;
            
            
            case 2:
                    if(rzad_obrabiany == 2)
                        ostateczny_wybor_zacisku();
                    
                    if(cykl_sterownik_4 < 5)  
                          cykl_sterownik_4 = sterownik_4_praca(a[2],1);
                    if(cykl_sterownik_4 == 5)
                        {
                        PORTE.2 = 1;  //wlacz szlifierke   
                        cykl_sterownik_4 = 0;
                        
                        //if((tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3) & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)
                        //     cykl_sterownik_4 = 5;
                        
                        sek13 = 0;   
                        cykl_glowny = 3;     
                        }         
            break;
            
            
            case 3:
                    
                     if(rzad_obrabiany == 2)
                        ostateczny_wybor_zacisku();
                    
                    if(cykl_sterownik_4 < 5 & sek13 > czas_druciaka_na_gorze & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli)
                         cykl_sterownik_4 = sterownik_4_praca(a[3],0); //INV 
                       
                    if(cykl_sterownik_4 == 5 & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli)
                        {
                        szczotka_druc_cykl++;
                        cykl_sterownik_4 = 0;
                        
                        if((tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3) & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)
                            cykl_sterownik_4 = 5;
                        
                        
                        
                        if((tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3) & szczotka_druc_cykl < szczotka_druciana_ilosc_cykli)
                               {
                               cykl_glowny = 2;
                               if(tryb_pracy_szczotki_drucianej == 2)
                                   PORTE.2 = 0;  //wylacz szlifierke
                               }
                        }
                    
                    if(cykl_sterownik_4 < 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli & tryb_pracy_szczotki_drucianej == 1)
                         cykl_sterownik_4 = sterownik_4_praca(0x03,0); //INV 
                    
                        
                        
                        if(cykl_sterownik_4 == 5 & szczotka_druc_cykl == szczotka_druciana_ilosc_cykli)
                            {
                            PORTE.2 = 0;  //wylacz szlifierke
                            cykl_sterownik_4 = 0;   
                            cykl_glowny = 4;
                            }
                                
            break;
            
            case 4:
            
                     
                      if(rzad_obrabiany == 2)
                            ostateczny_wybor_zacisku();
                     
                     if(cykl_sterownik_4 < 5)
                        cykl_sterownik_4 = sterownik_4_praca(0x01,0); 
                        
                     if(cykl_sterownik_4 == 5)
                        {
                        PORTE.2 = 0;  //wylacz szlifierke
                        cykl_sterownik_4 = 0;
                        ruch_zlozony = 0;
                        cykl_glowny = 5;
                        }            
            
            break;
            
            case 5:
            
            
                    if(cykl_sterownik_1 < 5 & ruch_zlozony == 0 & rzad_obrabiany == 1)
                        cykl_sterownik_1 = sterownik_1_praca(0x000);
                    if(cykl_sterownik_1 < 5 & ruch_zlozony == 0 & rzad_obrabiany == 2)
                        cykl_sterownik_1 = sterownik_1_praca(0x001);
                    
                     if(rzad_obrabiany == 2)
                        ostateczny_wybor_zacisku();
                    
                    if(cykl_sterownik_1 == 5 & ruch_zlozony == 0)
                        {
                        cykl_sterownik_1 = 0;
                        ruch_zlozony = 1;
                        }
                    
                    if(cykl_sterownik_1 < 5 & ruch_zlozony == 1 & rzad_obrabiany == 1)
                        cykl_sterownik_1 = sterownik_1_praca(a[0]);
                    if(cykl_sterownik_1 < 5 & ruch_zlozony == 1 & rzad_obrabiany == 2)
                          cykl_sterownik_1 = sterownik_1_praca(a[1]);
                    
                    
                    if(cykl_sterownik_1 < 5 & ruch_zlozony == 2)
                        cykl_sterownik_1 = sterownik_1_praca(0x003);     ////////////////////////////////////////////////////////////
                    
                    if(cykl_sterownik_2 < 5 & koniec_rzedu_10 == 0)                                //ster 1 do pierwszego dolka
                        cykl_sterownik_2 = sterownik_2_praca(0x003);       //ster 2 pod nastpeny dolek
                    
                    
                    if(cykl_sterownik_2 < 5 & koniec_rzedu_10 == 1 & rzad_obrabiany == 1)                                
                        cykl_sterownik_2 = sterownik_2_praca(0x008);      //ster 2 do samego tylu
                     if(cykl_sterownik_2 < 5 & koniec_rzedu_10 == 1 & rzad_obrabiany == 2)                                
                        cykl_sterownik_2 = sterownik_2_praca(0x009);      //ster 2 do samego tylu
                    
                    if((cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5 & ruch_zlozony == 1) | (cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5) & ruch_zlozony == 2)
                        {
                        cykl_sterownik_1 = 0;
                        cykl_sterownik_2 = 0;
                        cykl_sterownik_4 = 0;
                        cykl_sterownik_3 = 0;
                        PORTE.3 = 1;  //szlifierka 2 (krazek scierny)
                        cykl_glowny = 6;     
                        }
            
            break;
            
            case 6:
                            
                    if(cykl_sterownik_3 < 5)         
                        cykl_sterownik_3 = sterownik_3_praca(a[4]);  //abs //krazek scierny do gory
                        
                    if(koniec_rzedu_10 == 1)         
                        cykl_sterownik_4 = 5;
                        
                    if(cykl_sterownik_4 < 5) 
                        cykl_sterownik_4 = sterownik_4_praca(a[2],1);    //ABS          //druciak do gory
                    
                     if(rzad_obrabiany == 2)
                        ostateczny_wybor_zacisku();
                    
                        
                    if(cykl_sterownik_4 == 5 & cykl_sterownik_3 == 5)
                        {
                        if((cykl_ilosc_zaciskow != il_zaciskow_rzad_1 - 1 & rzad_obrabiany == 1) | (cykl_ilosc_zaciskow != il_zaciskow_rzad_2 - 1 & rzad_obrabiany == 2))
                            PORTE.2 = 1;  //wlacz szlifierke   
                        
                        PORTE.3 = 1;  //szlifierka 2 (krazek scierny)
                        cykl_sterownik_3 = 0;
                        cykl_sterownik_4 = 0;
                        if(cykl_ilosc_zaciskow > 0)
                                {
                                sek12 = 0;    //do przedmuchu
                                PORT_F.bits.b4 = 1;  //przedmuch zaciskow    
                                PORTF = PORT_F.byte;
                                }
                        sek13 = 0;
                        cykl_glowny = 7;     
                        }
           
           break;
      
      
           case 7:
                                                                                              
                  
                     if(rzad_obrabiany == 2)
                        ostateczny_wybor_zacisku();
                      
                        wykonalem_komplet_okregow = 0;     
                        szczotka_druc_cykl = 0;
                        krazek_scierny_cykl_po_okregu = 0;
                        krazek_scierny_cykl = 0;
                        powrot_przedwczesny_krazek_scierny = 0;
                        powrot_przedwczesny_druciak = 0;
                        
                        abs_ster3 = 0;
                        abs_ster4 = 0;
                        cykl_sterownik_1 = 0;
                        cykl_sterownik_2 = 0;
                        cykl_sterownik_4 = 0;
                        cykl_sterownik_3 = 0;
                        
                             if(krazek_scierny_cykl_po_okregu_ilosc > 0)
                                {
                                if(ruch_haos == 0 & tryb_pracy_szczotki_drucianej == 1)  //spr.
                                    cykl_glowny = 8;
                                
                                if(ruch_haos == 0 & (tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3))//spr.
                                    cykl_glowny = 88;
                                
                                if(ruch_haos == 1 & tryb_pracy_szczotki_drucianej == 1) //spr.
                                    cykl_glowny = 887;
                                
                                if(ruch_haos == 1 & (tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3))// spr.
                                    cykl_glowny = 888;
                                }
                             else
                                {
                                if(tryb_pracy_szczotki_drucianej == 1)  //spr
                                    cykl_glowny = 997;
                                if(tryb_pracy_szczotki_drucianej == 2 | tryb_pracy_szczotki_drucianej == 3)  //spr
                                    cykl_glowny = 998;
                                    
                                }
                             
           break;
           
           
           case 887:          
                    przypadek887();
           break;
           
            case 888:
                   przypadek888(); 
           break;
            
           case 997:
                   przypadek997();         
           break;
           
           case 998:
                    przypadek998();
           break;
            
            case 8:        
                    przypadek8();        
            break;       
                         
            case 88:
                    przypadek88();               
            break;       
            
            
            
            case 9:                                          //cykl 3 == 5
            
                         if(sek12 > czas_przedmuchu)
                        {
                        PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz    
                        PORTF = PORT_F.byte;  
                        }
                       
            
            
                         if(rzad_obrabiany == 1)
                         {
                         if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow != il_zaciskow_rzad_1 - 1)    //////
                              {
                              //if(sek21 > sek21_wylaczenie_szlif)
                              //  PORTE.3 = 0;  //szlifierka 2 (krazek scierny) - wylaczenie bo ocieralo
                              cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
                              }
                          
                          if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow < il_zaciskow_rzad_1 - 2)
                            cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej 
                          
                          
                         if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow == il_zaciskow_rzad_1 - 1)       //2 marca 2019 wykomentowuje ////////
                            {
                            //if(sek21 > sek21_wylaczenie_szlif)
                            //    PORTE.3 = 0;  //szlifierka 2 (krazek scierny) - wylaczenie bo ocieralo
                            cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
                            }
                         
                         if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow >= il_zaciskow_rzad_1 - 2)
                            cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
                         
                          }
                          
                         
                         if(rzad_obrabiany == 2)
                         {
                         if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow != il_zaciskow_rzad_2 - 1)
                            {
                            //if(sek21 > sek21_wylaczenie_szlif)
                            //    PORTE.3 = 0;  //szlifierka 2 (krazek scierny) - wylaczenie bo ocieralo
                            cykl_sterownik_3 = sterownik_3_praca(0x01);  //do pozycji bazowej
                            }
                          if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow < il_zaciskow_rzad_2 - 2)
                            cykl_sterownik_4 = sterownik_4_praca(0x01,0);  //do pozycji bazowej  
                          
                         if(cykl_sterownik_3 < 5 & cykl_ilosc_zaciskow == il_zaciskow_rzad_2 - 1)
                            {
                            //if(sek21 > sek21_wylaczenie_szlif)
                            //    PORTE.3 = 0;  //szlifierka 2 (krazek scierny) - wylaczenie bo ocieralo
                            cykl_sterownik_3 = sterownik_3_praca(0x00);  //na sam dol, jedziemy miedzy rzedami
                            }
                          if(cykl_sterownik_4 < 5 & cykl_ilosc_zaciskow >= il_zaciskow_rzad_2 - 2)
                            cykl_sterownik_4 = sterownik_4_praca(0x00,0);  //na sam dol, jedziemy miedzy rzedami
                         
                           if(rzad_obrabiany == 2)
                            ostateczny_wybor_zacisku();
                          
                          }
                         
                             
                          if(cykl_sterownik_3 == 5 & cykl_sterownik_4 == 5 & sek12 > czas_przedmuchu)
                            {
                            PORTE.2 = 0;  //wylacz szlifierke
                            PORTE.3 = 0;  //szlifierka 2 (krazek scierny)
                            //PORTB.6 = 0;  //wylacz przedmuchy
                            PORT_F.bits.b4 = 0;  //przedmuch zaciskow wylacz    
                            PORTF = PORT_F.byte;
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
                            wartosc_parametru_panelu(cykl_ilosc_zaciskow,0,96);  //wykonano zaciskow rzad1
                            if(srednica_wew_korpusu_cyklowa == 38 | srednica_wew_korpusu_cyklowa == 41 | srednica_wew_korpusu_cyklowa == 43)  
                            {
                            czas_pracy_szczotki_drucianej_h_17++;
                            if(czas_pracy_szczotki_drucianej_h_17 > 250)
                                czas_pracy_szczotki_drucianej_h_17 = 250;
                            }
                            
                            if(srednica_wew_korpusu_cyklowa == 34 | srednica_wew_korpusu_cyklowa == 36)  
                            {
                            czas_pracy_szczotki_drucianej_h_15++;
                            if(czas_pracy_szczotki_drucianej_h_15 > 250)
                                czas_pracy_szczotki_drucianej_h_15 = 250;
                            }
                            
                            
                            
                            
                            
                            if(srednica_wew_korpusu_cyklowa == 34)
                                {
                                czas_pracy_krazka_sciernego_h_34++;
                                if(czas_pracy_krazka_sciernego_h_34 > 250)
                                    czas_pracy_krazka_sciernego_h_34 = 250;
                                }
                            
                            
                            if(srednica_wew_korpusu_cyklowa == 36)
                                {
                                czas_pracy_krazka_sciernego_h_36++;
                                if(czas_pracy_krazka_sciernego_h_36 > 250)
                                    czas_pracy_krazka_sciernego_h_36 = 250;
                                }
                            if(srednica_wew_korpusu_cyklowa == 38)
                                {
                                czas_pracy_krazka_sciernego_h_38++;
                                if(czas_pracy_krazka_sciernego_h_38 > 250)
                                    czas_pracy_krazka_sciernego_h_38 = 250;
                                }
                            if(srednica_wew_korpusu_cyklowa == 41)
                                {
                                czas_pracy_krazka_sciernego_h_41++;
                                if(czas_pracy_krazka_sciernego_h_41 > 250)
                                    czas_pracy_krazka_sciernego_h_41 = 250;
                                }
                            if(srednica_wew_korpusu_cyklowa == 43)
                                {
                                czas_pracy_krazka_sciernego_h_43++;
                                if(czas_pracy_krazka_sciernego_h_43 > 250)
                                    czas_pracy_krazka_sciernego_h_43 = 250;
                                }
                            
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
                            
                            
                             if(rzad_obrabiany == 2)
                                ostateczny_wybor_zacisku();
                             
                            if(rzad_obrabiany == 2 & cykl_glowny != 0)
                            {
                            wartosc_parametru_panelu(cykl_ilosc_zaciskow,0,16);  //wykonano zaciskow rzad2
                            
                            if(srednica_wew_korpusu_cyklowa == 38 | srednica_wew_korpusu_cyklowa == 41 | srednica_wew_korpusu_cyklowa == 43)  
                            {
                            czas_pracy_szczotki_drucianej_h_17++;
                            if(czas_pracy_szczotki_drucianej_h_17 > 250)
                                czas_pracy_szczotki_drucianej_h_17 = 250;
                            }
                            
                            if(srednica_wew_korpusu_cyklowa == 34 | srednica_wew_korpusu_cyklowa == 36)  
                            {
                            czas_pracy_szczotki_drucianej_h_15++;
                            if(czas_pracy_szczotki_drucianej_h_15 > 250)
                                czas_pracy_szczotki_drucianej_h_15 = 250;
                            }
                            
                            
                            if(srednica_wew_korpusu_cyklowa == 34)
                                {
                                czas_pracy_krazka_sciernego_h_34++;
                                if(czas_pracy_krazka_sciernego_h_34 > 250)
                                    czas_pracy_krazka_sciernego_h_34 = 250;
                                }
                            
                            
                            if(srednica_wew_korpusu_cyklowa == 36)
                                {
                                czas_pracy_krazka_sciernego_h_36++;
                                if(czas_pracy_krazka_sciernego_h_36 > 250)
                                    czas_pracy_krazka_sciernego_h_36 = 250;
                                }
                            if(srednica_wew_korpusu_cyklowa == 38)
                                {
                                czas_pracy_krazka_sciernego_h_38++;
                                if(czas_pracy_krazka_sciernego_h_38 > 250)
                                    czas_pracy_krazka_sciernego_h_38 = 250;
                                }
                            if(srednica_wew_korpusu_cyklowa == 41)
                                {
                                czas_pracy_krazka_sciernego_h_41++;
                                if(czas_pracy_krazka_sciernego_h_41 > 250)
                                    czas_pracy_krazka_sciernego_h_41 = 250;
                                }
                            if(srednica_wew_korpusu_cyklowa == 43)
                                {
                                czas_pracy_krazka_sciernego_h_43++;
                                if(czas_pracy_krazka_sciernego_h_43 > 250)
                                    czas_pracy_krazka_sciernego_h_43 = 250;
                                }
                            
                            
                            if(srednica_wew_korpusu_cyklowa == 34)
                                czas_pracy_krazka_sciernego_h_34++;
                            if(srednica_wew_korpusu_cyklowa == 36)
                                czas_pracy_krazka_sciernego_h_36++;
                            if(srednica_wew_korpusu_cyklowa == 38)
                                czas_pracy_krazka_sciernego_h_38++;
                            if(srednica_wew_korpusu_cyklowa == 41)
                                czas_pracy_krazka_sciernego_h_41++;
                            if(srednica_wew_korpusu_cyklowa == 43)
                                czas_pracy_krazka_sciernego_h_43++;
                            
                            
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
                             
                              if(rzad_obrabiany == 2)
                                ostateczny_wybor_zacisku();
                             
                             //ster 1 ucieka od szafy
                             if(cykl_sterownik_1 < 5) 
                                    cykl_sterownik_1 = sterownik_1_praca(0x007);     //uciekamy do tylu
                             
                             if(cykl_sterownik_2 < 5) 
                                    cykl_sterownik_2 = sterownik_2_praca(0x190);     //pod dolek ostatni 10 do przedmuchu rzad 1
                             
                             if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
                                    {
                                    PORT_F.bits.b4 = 1;  //przedmuch zaciskow    
                                    PORTF = PORT_F.byte;
                                    PORTE.5 = 1;
                                    sek12 = 0;
                                    cykl_sterownik_1 = 0;
                                    cykl_sterownik_2 = 0;
                                    cykl_glowny = 13;
                                    }  
            break;
            
            
            case 12:
                             
                             if(rzad_obrabiany == 2)
                                ostateczny_wybor_zacisku();
                               
                               //ster 1 ucieka od szafy
                             if(cykl_sterownik_1 < 5) 
                                    cykl_sterownik_1 = sterownik_1_praca(0x007);     //uciekamy do tylu
                                    
                            if(cykl_sterownik_2 < 5) 
                                    cykl_sterownik_2 = sterownik_2_praca(0x191);     //pod dolek ostatni 10 do przedmuchu rzad 2
                            
                             if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
                                    {
                                    PORT_F.bits.b4 = 1;  //przedmuch zaciskow    
                                    PORTF = PORT_F.byte;
                                    PORTE.5 = 1;
                                    sek12 = 0;
                                    cykl_sterownik_1 = 0;
                                    cykl_sterownik_2 = 0;
                                    cykl_glowny = 13;
                                    }  
            
            
            break;
             
            case 13:        
                           
                             
                              if(rzad_obrabiany == 2)
                                ostateczny_wybor_zacisku();
                             
                              if(sek12 > czas_przedmuchu)
                                        {
                                        PORT_F.bits.b4 = 0;  //przedmuch zaciskow - wylaczenie   
                                        PORTF = PORT_F.byte;
                                        PORTE.5 = 0;
                                        }
                             
                             
                             if(cykl_sterownik_2 < 5) 
                                    cykl_sterownik_2 = sterownik_2_praca(0x192);     //okrag
                             if(cykl_sterownik_2 == 5)
                                    {
                                    
                                     if(sek12 > czas_przedmuchu)
                                        {
                                        PORT_F.bits.b4 = 0;  //przedmuch zaciskow - wylaczenie   
                                        PORTF = PORT_F.byte;
                                        PORTE.5 = 0;
                                        cykl_sterownik_2 = 0;
                                        cykl_glowny = 16;
                                        }
                                    }  
            
            break;
            
            
            
            case 14:
            
                  
                     if(rzad_obrabiany == 2)
                        ostateczny_wybor_zacisku();
                    
                    if(cykl_sterownik_1 < 5)    
                        cykl_sterownik_1 = sterownik_1_praca(0x003);     //pod nastepny dolek zeby przedmuchac
                    if(cykl_sterownik_1 == 5)
                        {
                        cykl_sterownik_1 = 0;
                        sek12 = 0;
                        cykl_glowny = 15;
                        }
            
            break;
            
            
       
            case 15:
            
                     if(rzad_obrabiany == 2)
                        ostateczny_wybor_zacisku();
                    
                    //przedmuch
                    PORT_F.bits.b4 = 1;  //przedmuch zaciskow    
                    PORTF = PORT_F.byte;
                    
                    if(start == 1)
                        {
                        obsluga_otwarcia_klapy_rzad();
                        obsluga_nacisniecia_zatrzymaj();
                        }
            
                    
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
                                PORTE.7 = 0;   //pusc zaciski
                                if(il_zaciskow_rzad_2 > 0)
                                    {
                                   
                                    rzad_obrabiany = 2;
                                    wybor_linijek_sterownikow(2);  //rzad 2
                                    cykl_glowny = 0;
                                    }
                                else
                                    cykl_glowny = 17;
                                    
                                wykonalem_rzedow = 1;
                                }
                       
                       if(cykl_ilosc_zaciskow == il_zaciskow_rzad_2 & il_zaciskow_rzad_2 > 0 & wykonalem_rzedow == 1)   ///////////////////zmieniam + 1 20.02
                                {
                                PORTE.7 = 0;   //pusc zaciski
                                cykl_ilosc_zaciskow = 0;
                                cykl_glowny = 17;
                                rzad_obrabiany = 1;
                                wykonalem_rzedow = 2;
                                }
            
            
                        if(il_zaciskow_rzad_1 > 0 & il_zaciskow_rzad_2 > 0 & wykonalem_rzedow == 2)
                                  {
                                  rzad_obrabiany = 1;
                                  wykonalem_rzedow = 0;
                                  PORTE.7 = 0;   //pusc zaciski
                                  //PORTE.6 = 0;    //przelacz rzad zaciskow - rzad 1 - tego na razie nie poki nie ma oslon
                                  //PORTB.6 = 0;   ////zielona lampka
                                  //wartosc_parametru_panelu(0,0,64);
                                  }
                          
                            if(il_zaciskow_rzad_1 > 0 & il_zaciskow_rzad_2 == 0 & wykonalem_rzedow == 1)
                                  {
                                  rzad_obrabiany = 1;
                                  wykonalem_rzedow = 0;
                                  //PORTE.6 = 1;    //przelacz rzad zaciskow - rzad 2
                                  }
            
            
            
            break;
            
            
            case 17:
            
                                 
                                 if(cykl_sterownik_1 < 5)
                                    cykl_sterownik_1 = sterownik_1_praca(0x009);
                                 if(cykl_sterownik_2 < 5)                                //ster 1 do 0
                                    cykl_sterownik_2 = sterownik_2_praca(0x000);       //ster 2 pod pin pozy rzad 1
                                    
                                    if(cykl_sterownik_1 == 5 & cykl_sterownik_2 == 5)
                                        {
                                        PORTB.6 = 0;   ////zielona lampka
                                        cykl_sterownik_1 = 0;
                                        cykl_sterownik_2 = 0;
                                        cykl_sterownik_3 = 0;
                                        cykl_sterownik_4 = 0;
                                        jestem_w_trakcie_czyszczenia_calosci = 0;
                                        PORTB.6 = 0;
                                        
                                        if(odczytalem_w_trakcie_czyszczenia_drugiego_rzedu == 0)
                                        {
                                        macierz_zaciskow[1]=0;
                                        macierz_zaciskow[2]=0;
                                        
                                        komunikat_na_panel("-------",0,80);  //rzad 1
                                        komunikat_na_panel("-------",0,32);  //rzad 2
                                        
                                        komunikat_na_panel("                                                ",128,144);
                                        komunikat_na_panel("Wczytaj zacisk ten sam lub nowy",128,144);
                                        komunikat_na_panel("                                                ",144,80);
                                        komunikat_na_panel("Wczytaj zacisk ten sam lub nowy",144,80);
                                        }
                                        
                                        odczytalem_w_trakcie_czyszczenia_drugiego_rzedu = 0;
                                        
                                        
                                        //to ponizej dotyczy zapisu do pamieci stalej cykli szczotki i krazka
                                        
                                        tryb_pracy_szczotki_drucianej = odczytaj_parametr(0,112);
                                        szczotka_druciana_ilosc_cykli = odczytaj_parametr(48,64); 
                                        krazek_scierny_ilosc_cykli = odczytaj_parametr(32,144);        
                                        krazek_scierny_cykl_po_okregu_ilosc = odczytaj_parametr(48,0);
                                        czas_pracy_szczotki_drucianej_stala = odczytaj_parametr(16,112);
                                        czas_pracy_krazka_sciernego_stala = odczytaj_parametr(32,16);
                                        
                                        wartosci_wstepne_wgrac_tylko_raz(1); //to trwa 3s
                                        srednica_wew_korpusu_cyklowa = 0;
                                        wartosc_parametru_panelu(0,0,64);
                                        start = 0;
                                        cykl_glowny = 0;
                                        }
                                       
            
            
            
            break;
            
            
            
            }//switch

         
  }//while
 
      

}//while glowny




}//koniec




