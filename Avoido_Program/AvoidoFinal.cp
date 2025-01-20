#line 1 "C:/Users/jilde/Desktop/PSUT/Y4S1/Embedded Systems [22442]/Project/Final_Submission_QMS/Official/Avoido/Avoido_Program/AvoidoFinal.c"
unsigned int calculate_distance(char);
void ADCinit(void);
unsigned int ADCread(void);
void initPWM(void);
void goForward(void);
void goLeft(void);
void goRight(void);
void servoINIT(void);
void mydelay_ms(unsigned int);
void delay10us(void);


unsigned int delayms;
unsigned Counter;

unsigned char tmr1LTemp;
unsigned char tmr1HTemp;

unsigned int middleSensor, rightSensor, leftSensor;
unsigned char previousState = 1;

unsigned int lightIntensity;

char HL;
unsigned char angle;


void interrupt(void){
 if (INTCON & 0x04) {
 Counter++;
 INTCON = INTCON & 0xFB;
 TMR0 = 236;
 }

 if(INTCON & 0x02){
 PORTC = PORTC & 0x0F;
 while(!(PORTB & 0x01)){
 PORTA = PORTA | 0x06;

 mydelay_ms(500);
 PORTA = PORTA & 0xF9;

 mydelay_ms(500);
 }
 PORTA = PORTA | 0x02;
 PORTA = PORTA & 0x03;
 INTCON = INTCON & 0xFD;
 }
 else if(PIR1 & 0x04) {
 if(!HL){
 CCPR1H = angle >> 8;
 CCPR1L = angle;
 HL = 0;
 CCP1CON = 0x09;
 }
 else{
 CCPR1H = (40000 - angle) >> 8;
 CCPR1L = (40000 - angle);
 CCP1CON = 0x08;
 HL = 1;
 }
 TMR1H = 0x00;
 TMR1L = 0x00;
 PIR1 = PIR1 & 0xFB;
 }
 else {INTCON = 0xF0;}
}


void main(void){
 TRISA = 0x01;
 TRISB = 0x01;
 TRISC = 0x00;
 TRISD = 0x15;
 TRISE = 0x00;

 PORTA = PORTA | 0x02;
 PORTA = PORTA & 0xFB;

 OPTION_REG = 0x80;
 INTCON = 0xF0;


 ADCinit();
 initPWM();
 servoINIT();

 while(1){

 middleSensor = calculate_distance(0)/10;
 rightSensor = calculate_distance(1)/10;
 leftSensor = calculate_distance(2)/10;


 if(middleSensor >= 2) {goForward();}
 else if(rightSensor >= 2) {goRight();}
 else if(leftSensor >= 2) {goLeft();}
 else{goRight();}



 lightIntensity = ADCread();
 if(lightIntensity > 818){
 previousState = 0;
 PORTA = PORTA & 0x01;
 angle = 1000;
 }
 else{
 previousState = 1;
 PORTA = PORTA | 0x02;
 angle = 3100;
 }
 }
}

void ADCinit(void){
 ADCON0 = 0x41;
 ADCON1 = 0xCE;
}

unsigned int ADCread(void){
 ADCON0 = ADCON0 | 0x04;
 while(ADCON0 & 0x04);

 return ((ADRESH << 8) | ADRESL);
}



unsigned int calculate_distance(char sensorNumber){
 unsigned int time = 0, distance;
 unsigned char triggerPin = 0, echoPin = 0;


 if(sensorNumber == 0){
 triggerPin = 0x02;
 echoPin = 0x01;
 }
 else if(sensorNumber == 1){
 triggerPin = 0x08;
 echoPin = 0x04;
 }
 else{
 triggerPin = 0x20;
 echoPin = 0x10;
 }


 PORTD = PORTD | triggerPin;
 delay10us();
 PORTD = PORTD & ~triggerPin;


 while (!(PORTD & echoPin));


 TMR1H = 0;
 TMR1L = 0;


 T1CON = 0x01;


 while (PORTD & echoPin);


 T1CON = 0x00;


 time = (TMR1H << 8) | TMR1L;


 distance = time / 58.82;

 return distance;
}

void initPWM(void){
 T2CON = 0x07;
 CCP2CON = 0x0C;
 PR2 = 0xFA;
 CCPR2L = 0x7D;
}



void goForward(void){
 PORTC = 0x90;
}


void goRight(void){
 PORTC = 0x50;
}


void goLeft(void){
 PORTC = 0xA0;
}

void servoINIT(void){
 TMR1H = 0x00;
 TMR1L = 0x00;

 HL = 1;
 CCP1CON = 0x08;

 T1CON = 0x01;

 PIE1 = PIE1 | 0x04;

 CCPR1H = 2000 >> 8;
 CCPR1L = 2000;
}

void mydelay_ms(unsigned int ms) {
 delayms = ms;
 Counter = 0;
 while (Counter < delayms);
}

void delay10us(void){
 char i;
 for(i = 0; i < 10; i++){
 asm NOP;
 asm NOP;
 }
}
