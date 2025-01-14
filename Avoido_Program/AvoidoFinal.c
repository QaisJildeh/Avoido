unsigned int LDR(void);
unsigned int calculate_distance(char);
void ADCinit(void);
unsigned int ADCread(void);
void initPWM(void);
void goForward(void);
void goLeft(void);
void goRight(void);
void servoINIT(void);
void mydelay_ms(unsigned int);


// Variables for delay
unsigned int delayms;
unsigned Counter;
// Variables for Interrupts
unsigned char tmr1LTemp;
unsigned char tmr1HTemp;
// Variables for main
unsigned int middleSensor, rightSensor, leftSensor;
unsigned char previousState = 1; // 1 ==> Light Enviroment 0 ==> Dark Enviroment
// Variables for LDR
unsigned int lightIntensity;
// Variables for Servo
char HL; // High Low State
unsigned char angle;
//Variables for Delays
unsigned char timer;

void interrupt(void){
   if(INTCON & 0x02){ // Check for external interrupt
       PORTC = PORTC & 0x0F;
       while(!(PORTB & 0x01)){
           PORTA = PORTA | 0x06;
           //delayTMR1(1);
           mydelay_ms(500);
           PORTA = PORTA & 0xF9;
           // //delayTMR1(1);
           mydelay_ms(500);
       }
       PORTA = PORTA | 0x02;
       PORTA = PORTA & 0x03;
       INTCON = INTCON & 0xFD;
   }


   if (INTCON & 0x04) {  // Timer0 overflow
       Counter++;
       INTCON = INTCON & 0xFB; // Clear the Timer0 overflow flag
       TMR0 = 236;             // Reset Timer0 for the next overflow
   }




   else if(PIR1 & 0x04) { // CCP1 interrupt
       if(!HL){ // High state
           CCPR1H = angle >> 8;
           CCPR1L = angle;
           HL = 0; // Switch to low state
           CCP1CON = 0x09; // Compare mode, clear output on match
       }
       else{ // Low state
           CCPR1H = (40000 - angle) >> 8; // Calculate low state duration
           CCPR1L = (40000 - angle);
           CCP1CON = 0x08; // Compare mode, set output on match
           HL = 1; // Switch to high state
       }
       TMR1H = 0x00;
       TMR1L = 0x00;
       PIR1 = PIR1 & 0xFB; // Clear CCP1 interrupt flag
   }
   else {INTCON = 0xF0;} // Any other interrupts are not allowed
}


void main(void){
   TRISA = 0x01; // A0 only analog input, everything else is a digital output
   TRISB = 0x01; // RB0 input for interrupt
   TRISC = 0x00; // Port C all outputs, RC1 --> PWM for H-Bridge, RC2 --> Compare for Servo Motor
   TRISD = 0x15; // D0 --> D5 for ultrasonic sensor
   TRISE = 0x00; // Unimplemented

   PORTA = PORTA | 0x02;
   PORTA = PORTA & 0xFB;

   OPTION_REG = 0x80;
   INTCON = 0xF0;


   ADCinit();
   initPWM();
   TMR1H = 0;
   TMR1L = 0;


   HL = 1; // Start with high state
   CCP1CON = 0x08; // Compare mode, set output on match


   T1CON = 0x01; // Timer1 On Fosc/4 (inc 0.5µs) with no prescaler


   //INTCON = 0xC0; // Enable global and peripheral interrupts
   PIE1 |= 0x04; // Enable CCP1 interrupts


   CCPR1H = 2000 >> 8; // Initial compare value for high state
   CCPR1L = 2000;




   while(1){
       // Any value distance that is less that 10cm is considered to be too close, change direction
       middleSensor = calculate_distance(0)/10;
       rightSensor = calculate_distance(1)/10;
       leftSensor = calculate_distance(2)/10;


       // Movement code for H-Bridge
       if(middleSensor >= 2) {goForward();}
       else if(rightSensor >= 2) {goRight();}
       else if(leftSensor >= 2) {goLeft();}
       else{goRight();}    // Keep turing right (counter clockwise in position) until front is clear


       // Night Vision
       lightIntensity = ADCread();
       // ! Re-callibrate
       if(lightIntensity > 818){  // 1KOhm, ~4.0V  && previousState
           previousState = 0;
           PORTA = PORTA & 0x01;   // Turn on LEDs ==> 0
           angle = 1000; // Set angle to 0 degrees
       }
       else{ //  if(lightIntensity <= 818 && !previousState)
           previousState = 1;
           PORTA = PORTA | 0x02;   // Turn off LEDs ==> 1
           angle = 3100; // Set angle to 0 degrees
       }


   }
}


void ADCinit(void){
   ADCON0 = 0x41;  // ATD ON, Don't GO, Channel 0, Fosc/16
   ADCON1 = 0xCE;  // All channels are Digital except RA0/AN0 is Analog, 500 KHz, right justified
}


unsigned int ADCread(void){
   ADCON0 = ADCON0 | 0x04; // GO
   while(ADCON0 & 0x04);


   return ((ADRESH << 8) | ADRESL);
}


// Ultrasonic sensor distance calculation function
unsigned int calculate_distance(char sensorNumber){
   unsigned int time = 0, distance;
   unsigned char triggerPin = 0, echoPin = 0; // Initialize to prevent undefined behavior


   // Assign trigger and echo pins based on sensorNumber
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


   // Send Trigger Pulse
   PORTD = PORTD | triggerPin; // Set trigger pin HIGH
   Delay_us(10);        // Wait for 10 microseconds
   PORTD = PORTD & ~triggerPin; // Set trigger pin LOW


   // Wait for Echo Start
   while (!(PORTD & echoPin)); // Wait until echo pin goes HIGH


   // Reset Timer Before Measurement
   TMR1H = 0;
   TMR1L = 0;


   // Start Timer
   T1CON = 0x01;


   // Wait for Echo End
   while (PORTD & echoPin); // Wait until echo pin goes LOW


   // Stop Timer
   T1CON = 0x00;


   // Read Timer Value
   time = (TMR1H << 8) | TMR1L;


   // Convert Time to Distance (assuming speed of sound = 343 m/s)
   distance = time / 58.82; // Distance in cm


   return distance; // Return Distance
}


void initPWM(void){
   PORTB = 0x00;
   T2CON = 0x07; // Turn on Timer 2 + Prescaler 1:16
   CCP2CON = 0x0C; // Two LSBs of duty cycle
   PR2 = 0xFA; // ==> 0.5x10^-6 x 250 x 16 = 2ms
   CCPR2L = 0x7D; // 50% PWM
}


// Move forward
void goForward(void){
   PORTC = 0x90; // Enable left and right forward
}


// Keep turning right in position
void goRight(void){
   PORTC = 0x50; // Enable right backward and left forward
}


// Keep turning left in position
void goLeft(void){
   PORTC = 0xA0; // Enable left backward and right forward
}


void servoINIT(void){
   TMR1H = 0x00;
   TMR1L = 0x00;


   HL = 1; // Start with high state
   CCP1CON = 0x08; // Compare mode Set output on match


   T1CON = 0x01; // Timer1 On Fosc/4 (inc 0.5µs) with no prescaler


   PIE1 = PIE1 | 0x04; // Enable CCP1 interrupts


   CCPR1H = 2000 >> 8; // Initial compare value for high state
   CCPR1L = 2000;
}


// // Merged function for different delay times.
void mydelay_ms(unsigned int ms) {
   delayms = ms; // 1 overflow = 1 ms
   Counter = 0;                 // Reset overflow counter
   while (timer < delayms);
}