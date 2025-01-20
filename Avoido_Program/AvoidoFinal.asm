
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;AvoidoFinal.c,28 :: 		void interrupt(void){
;AvoidoFinal.c,29 :: 		if (INTCON & 0x04) {  // Timer0 overflow
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt0
;AvoidoFinal.c,30 :: 		Counter++;
	INCF       _Counter+0, 1
	BTFSC      STATUS+0, 2
	INCF       _Counter+1, 1
;AvoidoFinal.c,31 :: 		INTCON = INTCON & 0xFB; // Clear the Timer0 overflow flag
	MOVLW      251
	ANDWF      INTCON+0, 1
;AvoidoFinal.c,32 :: 		TMR0 = 236;             // Reset Timer0 for the next overflow
	MOVLW      236
	MOVWF      TMR0+0
;AvoidoFinal.c,33 :: 		}
L_interrupt0:
;AvoidoFinal.c,35 :: 		if(INTCON & 0x02){ // Check for external interrupt
	BTFSS      INTCON+0, 1
	GOTO       L_interrupt1
;AvoidoFinal.c,36 :: 		PORTC = PORTC & 0x0F;
	MOVLW      15
	ANDWF      PORTC+0, 1
;AvoidoFinal.c,37 :: 		while(!(PORTB & 0x01)){
L_interrupt2:
	BTFSC      PORTB+0, 0
	GOTO       L_interrupt3
;AvoidoFinal.c,38 :: 		PORTA = PORTA | 0x06;
	MOVLW      6
	IORWF      PORTA+0, 1
;AvoidoFinal.c,40 :: 		mydelay_ms(500);
	MOVLW      244
	MOVWF      FARG_mydelay_ms+0
	MOVLW      1
	MOVWF      FARG_mydelay_ms+1
	CALL       _mydelay_ms+0
;AvoidoFinal.c,41 :: 		PORTA = PORTA & 0xF9;
	MOVLW      249
	ANDWF      PORTA+0, 1
;AvoidoFinal.c,43 :: 		mydelay_ms(500);
	MOVLW      244
	MOVWF      FARG_mydelay_ms+0
	MOVLW      1
	MOVWF      FARG_mydelay_ms+1
	CALL       _mydelay_ms+0
;AvoidoFinal.c,44 :: 		}
	GOTO       L_interrupt2
L_interrupt3:
;AvoidoFinal.c,45 :: 		PORTA = PORTA | 0x02;
	BSF        PORTA+0, 1
;AvoidoFinal.c,46 :: 		PORTA = PORTA & 0x03;
	MOVLW      3
	ANDWF      PORTA+0, 1
;AvoidoFinal.c,47 :: 		INTCON = INTCON & 0xFD;
	MOVLW      253
	ANDWF      INTCON+0, 1
;AvoidoFinal.c,48 :: 		}
	GOTO       L_interrupt4
L_interrupt1:
;AvoidoFinal.c,49 :: 		else if(PIR1 & 0x04) { // CCP1 interrupt
	BTFSS      PIR1+0, 2
	GOTO       L_interrupt5
;AvoidoFinal.c,50 :: 		if(!HL){ // High state
	MOVF       _HL+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt6
;AvoidoFinal.c,51 :: 		CCPR1H = angle >> 8;
	CLRF       CCPR1H+0
;AvoidoFinal.c,52 :: 		CCPR1L = angle;
	MOVF       _angle+0, 0
	MOVWF      CCPR1L+0
;AvoidoFinal.c,53 :: 		HL = 0; // Switch to low state
	CLRF       _HL+0
;AvoidoFinal.c,54 :: 		CCP1CON = 0x09; // Compare mode, clear output on match
	MOVLW      9
	MOVWF      CCP1CON+0
;AvoidoFinal.c,55 :: 		}
	GOTO       L_interrupt7
L_interrupt6:
;AvoidoFinal.c,57 :: 		CCPR1H = (40000 - angle) >> 8; // Calculate low state duration
	MOVF       _angle+0, 0
	SUBLW      64
	MOVWF      R3+0
	MOVLW      0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBLW      156
	MOVWF      R3+1
	MOVF       R3+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      CCPR1H+0
;AvoidoFinal.c,58 :: 		CCPR1L = (40000 - angle);
	MOVF       R3+0, 0
	MOVWF      CCPR1L+0
;AvoidoFinal.c,59 :: 		CCP1CON = 0x08; // Compare mode, set output on match
	MOVLW      8
	MOVWF      CCP1CON+0
;AvoidoFinal.c,60 :: 		HL = 1; // Switch to high state
	MOVLW      1
	MOVWF      _HL+0
;AvoidoFinal.c,61 :: 		}
L_interrupt7:
;AvoidoFinal.c,62 :: 		TMR1H = 0x00;
	CLRF       TMR1H+0
;AvoidoFinal.c,63 :: 		TMR1L = 0x00;
	CLRF       TMR1L+0
;AvoidoFinal.c,64 :: 		PIR1 = PIR1 & 0xFB; // Clear CCP1 interrupt flag
	MOVLW      251
	ANDWF      PIR1+0, 1
;AvoidoFinal.c,65 :: 		}
	GOTO       L_interrupt8
L_interrupt5:
;AvoidoFinal.c,66 :: 		else {INTCON = 0xF0;} // Any other interrupts are not allowed
	MOVLW      240
	MOVWF      INTCON+0
L_interrupt8:
L_interrupt4:
;AvoidoFinal.c,67 :: 		}
L_end_interrupt:
L__interrupt35:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;AvoidoFinal.c,70 :: 		void main(void){
;AvoidoFinal.c,71 :: 		TRISA = 0x01; // A0 only analog input, everything else is a digital output
	MOVLW      1
	MOVWF      TRISA+0
;AvoidoFinal.c,72 :: 		TRISB = 0x01; // RB0 input for interrupt
	MOVLW      1
	MOVWF      TRISB+0
;AvoidoFinal.c,73 :: 		TRISC = 0x00; // Port C all outputs, RC1 --> PWM for H-Bridge, RC2 --> Compare for Servo Motor
	CLRF       TRISC+0
;AvoidoFinal.c,74 :: 		TRISD = 0x15; // D0 --> D5 for ultrasonic sensor
	MOVLW      21
	MOVWF      TRISD+0
;AvoidoFinal.c,75 :: 		TRISE = 0x00; // Unimplemented
	CLRF       TRISE+0
;AvoidoFinal.c,77 :: 		PORTA = PORTA | 0x02;
	BSF        PORTA+0, 1
;AvoidoFinal.c,78 :: 		PORTA = PORTA & 0xFB;
	MOVLW      251
	ANDWF      PORTA+0, 1
;AvoidoFinal.c,80 :: 		OPTION_REG = 0x80;
	MOVLW      128
	MOVWF      OPTION_REG+0
;AvoidoFinal.c,81 :: 		INTCON = 0xF0;
	MOVLW      240
	MOVWF      INTCON+0
;AvoidoFinal.c,84 :: 		ADCinit();
	CALL       _ADCinit+0
;AvoidoFinal.c,85 :: 		initPWM();
	CALL       _initPWM+0
;AvoidoFinal.c,86 :: 		servoINIT();
	CALL       _servoINIT+0
;AvoidoFinal.c,88 :: 		while(1){
L_main9:
;AvoidoFinal.c,90 :: 		middleSensor = calculate_distance(0)/10;
	CLRF       FARG_calculate_distance+0
	CALL       _calculate_distance+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      _middleSensor+0
	MOVF       R0+1, 0
	MOVWF      _middleSensor+1
;AvoidoFinal.c,91 :: 		rightSensor = calculate_distance(1)/10;
	MOVLW      1
	MOVWF      FARG_calculate_distance+0
	CALL       _calculate_distance+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      _rightSensor+0
	MOVF       R0+1, 0
	MOVWF      _rightSensor+1
;AvoidoFinal.c,92 :: 		leftSensor = calculate_distance(2)/10;
	MOVLW      2
	MOVWF      FARG_calculate_distance+0
	CALL       _calculate_distance+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      _leftSensor+0
	MOVF       R0+1, 0
	MOVWF      _leftSensor+1
;AvoidoFinal.c,95 :: 		if(middleSensor >= 2) {goForward();}
	MOVLW      0
	SUBWF      _middleSensor+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main37
	MOVLW      2
	SUBWF      _middleSensor+0, 0
L__main37:
	BTFSS      STATUS+0, 0
	GOTO       L_main11
	CALL       _goForward+0
	GOTO       L_main12
L_main11:
;AvoidoFinal.c,96 :: 		else if(rightSensor >= 2) {goRight();}
	MOVLW      0
	SUBWF      _rightSensor+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main38
	MOVLW      2
	SUBWF      _rightSensor+0, 0
L__main38:
	BTFSS      STATUS+0, 0
	GOTO       L_main13
	CALL       _goRight+0
	GOTO       L_main14
L_main13:
;AvoidoFinal.c,97 :: 		else if(leftSensor >= 2) {goLeft();}
	MOVLW      0
	SUBWF      _leftSensor+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main39
	MOVLW      2
	SUBWF      _leftSensor+0, 0
L__main39:
	BTFSS      STATUS+0, 0
	GOTO       L_main15
	CALL       _goLeft+0
	GOTO       L_main16
L_main15:
;AvoidoFinal.c,98 :: 		else{goRight();}    // Keep turing right (counter clockwise in position) until front is clear
	CALL       _goRight+0
L_main16:
L_main14:
L_main12:
;AvoidoFinal.c,102 :: 		lightIntensity = ADCread();
	CALL       _ADCread+0
	MOVF       R0+0, 0
	MOVWF      _lightIntensity+0
	MOVF       R0+1, 0
	MOVWF      _lightIntensity+1
;AvoidoFinal.c,103 :: 		if(lightIntensity > 818){  // 1KOhm, ~4.0V  && previousState
	MOVF       R0+1, 0
	SUBLW      3
	BTFSS      STATUS+0, 2
	GOTO       L__main40
	MOVF       R0+0, 0
	SUBLW      50
L__main40:
	BTFSC      STATUS+0, 0
	GOTO       L_main17
;AvoidoFinal.c,104 :: 		previousState = 0;
	CLRF       _previousState+0
;AvoidoFinal.c,105 :: 		PORTA = PORTA & 0x01;   // Turn on LEDs ==> 0
	MOVLW      1
	ANDWF      PORTA+0, 1
;AvoidoFinal.c,106 :: 		angle = 1000; // Set angle to 0 degrees
	MOVLW      232
	MOVWF      _angle+0
;AvoidoFinal.c,107 :: 		}
	GOTO       L_main18
L_main17:
;AvoidoFinal.c,109 :: 		previousState = 1;
	MOVLW      1
	MOVWF      _previousState+0
;AvoidoFinal.c,110 :: 		PORTA = PORTA | 0x02;   // Turn off LEDs ==> 1
	BSF        PORTA+0, 1
;AvoidoFinal.c,111 :: 		angle = 3100; // Set angle to 0 degrees
	MOVLW      28
	MOVWF      _angle+0
;AvoidoFinal.c,112 :: 		}
L_main18:
;AvoidoFinal.c,113 :: 		}
	GOTO       L_main9
;AvoidoFinal.c,114 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_ADCinit:

;AvoidoFinal.c,116 :: 		void ADCinit(void){
;AvoidoFinal.c,117 :: 		ADCON0 = 0x41;  // ATD ON, Don't GO, Channel 0, Fosc/16
	MOVLW      65
	MOVWF      ADCON0+0
;AvoidoFinal.c,118 :: 		ADCON1 = 0xCE;  // All channels are Digital except RA0/AN0 is Analog, 500 KHz, right justified
	MOVLW      206
	MOVWF      ADCON1+0
;AvoidoFinal.c,119 :: 		}
L_end_ADCinit:
	RETURN
; end of _ADCinit

_ADCread:

;AvoidoFinal.c,121 :: 		unsigned int ADCread(void){
;AvoidoFinal.c,122 :: 		ADCON0 = ADCON0 | 0x04; // GO
	BSF        ADCON0+0, 2
;AvoidoFinal.c,123 :: 		while(ADCON0 & 0x04);
L_ADCread19:
	BTFSS      ADCON0+0, 2
	GOTO       L_ADCread20
	GOTO       L_ADCread19
L_ADCread20:
;AvoidoFinal.c,125 :: 		return ((ADRESH << 8) | ADRESL);
	MOVF       ADRESH+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       ADRESL+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
;AvoidoFinal.c,126 :: 		}
L_end_ADCread:
	RETURN
; end of _ADCread

_calculate_distance:

;AvoidoFinal.c,130 :: 		unsigned int calculate_distance(char sensorNumber){
;AvoidoFinal.c,131 :: 		unsigned int time = 0, distance;
;AvoidoFinal.c,132 :: 		unsigned char triggerPin = 0, echoPin = 0; // Initialize to prevent undefined behavior
	CLRF       calculate_distance_triggerPin_L0+0
	CLRF       calculate_distance_echoPin_L0+0
;AvoidoFinal.c,135 :: 		if(sensorNumber == 0){
	MOVF       FARG_calculate_distance_sensorNumber+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_calculate_distance21
;AvoidoFinal.c,136 :: 		triggerPin = 0x02;
	MOVLW      2
	MOVWF      calculate_distance_triggerPin_L0+0
;AvoidoFinal.c,137 :: 		echoPin = 0x01;
	MOVLW      1
	MOVWF      calculate_distance_echoPin_L0+0
;AvoidoFinal.c,138 :: 		}
	GOTO       L_calculate_distance22
L_calculate_distance21:
;AvoidoFinal.c,139 :: 		else if(sensorNumber == 1){
	MOVF       FARG_calculate_distance_sensorNumber+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_calculate_distance23
;AvoidoFinal.c,140 :: 		triggerPin = 0x08;
	MOVLW      8
	MOVWF      calculate_distance_triggerPin_L0+0
;AvoidoFinal.c,141 :: 		echoPin = 0x04;
	MOVLW      4
	MOVWF      calculate_distance_echoPin_L0+0
;AvoidoFinal.c,142 :: 		}
	GOTO       L_calculate_distance24
L_calculate_distance23:
;AvoidoFinal.c,144 :: 		triggerPin = 0x20;
	MOVLW      32
	MOVWF      calculate_distance_triggerPin_L0+0
;AvoidoFinal.c,145 :: 		echoPin = 0x10;
	MOVLW      16
	MOVWF      calculate_distance_echoPin_L0+0
;AvoidoFinal.c,146 :: 		}
L_calculate_distance24:
L_calculate_distance22:
;AvoidoFinal.c,149 :: 		PORTD = PORTD | triggerPin; // Set trigger pin HIGH
	MOVF       calculate_distance_triggerPin_L0+0, 0
	IORWF      PORTD+0, 1
;AvoidoFinal.c,150 :: 		delay10us();        // Wait for 10 microseconds
	CALL       _delay10us+0
;AvoidoFinal.c,151 :: 		PORTD = PORTD & ~triggerPin; // Set trigger pin LOW
	COMF       calculate_distance_triggerPin_L0+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	ANDWF      PORTD+0, 1
;AvoidoFinal.c,154 :: 		while (!(PORTD & echoPin)); // Wait until echo pin goes HIGH
L_calculate_distance25:
	MOVF       calculate_distance_echoPin_L0+0, 0
	ANDWF      PORTD+0, 0
	MOVWF      R0+0
	BTFSS      STATUS+0, 2
	GOTO       L_calculate_distance26
	GOTO       L_calculate_distance25
L_calculate_distance26:
;AvoidoFinal.c,157 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;AvoidoFinal.c,158 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;AvoidoFinal.c,161 :: 		T1CON = 0x01;
	MOVLW      1
	MOVWF      T1CON+0
;AvoidoFinal.c,164 :: 		while (PORTD & echoPin); // Wait until echo pin goes LOW
L_calculate_distance27:
	MOVF       calculate_distance_echoPin_L0+0, 0
	ANDWF      PORTD+0, 0
	MOVWF      R0+0
	BTFSC      STATUS+0, 2
	GOTO       L_calculate_distance28
	GOTO       L_calculate_distance27
L_calculate_distance28:
;AvoidoFinal.c,167 :: 		T1CON = 0x00;
	CLRF       T1CON+0
;AvoidoFinal.c,170 :: 		time = (TMR1H << 8) | TMR1L;
	MOVF       TMR1H+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       TMR1L+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
;AvoidoFinal.c,173 :: 		distance = time / 58.82; // Distance in cm
	CALL       _word2double+0
	MOVLW      174
	MOVWF      R4+0
	MOVLW      71
	MOVWF      R4+1
	MOVLW      107
	MOVWF      R4+2
	MOVLW      132
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	CALL       _double2word+0
;AvoidoFinal.c,175 :: 		return distance; // Return Distance
;AvoidoFinal.c,176 :: 		}
L_end_calculate_distance:
	RETURN
; end of _calculate_distance

_initPWM:

;AvoidoFinal.c,178 :: 		void initPWM(void){
;AvoidoFinal.c,179 :: 		T2CON = 0x07; // Turn on Timer 2 + Prescaler 1:16
	MOVLW      7
	MOVWF      T2CON+0
;AvoidoFinal.c,180 :: 		CCP2CON = 0x0C; // Two LSBs of duty cycle
	MOVLW      12
	MOVWF      CCP2CON+0
;AvoidoFinal.c,181 :: 		PR2 = 0xFA; // ==> 0.5x10^-6 x 250 x 16 = 2ms
	MOVLW      250
	MOVWF      PR2+0
;AvoidoFinal.c,182 :: 		CCPR2L = 0x7D; // 50% PWM
	MOVLW      125
	MOVWF      CCPR2L+0
;AvoidoFinal.c,183 :: 		}
L_end_initPWM:
	RETURN
; end of _initPWM

_goForward:

;AvoidoFinal.c,187 :: 		void goForward(void){
;AvoidoFinal.c,188 :: 		PORTC = 0x90; // Enable left and right forward
	MOVLW      144
	MOVWF      PORTC+0
;AvoidoFinal.c,189 :: 		}
L_end_goForward:
	RETURN
; end of _goForward

_goRight:

;AvoidoFinal.c,192 :: 		void goRight(void){
;AvoidoFinal.c,193 :: 		PORTC = 0x50; // Enable right backward and left forward
	MOVLW      80
	MOVWF      PORTC+0
;AvoidoFinal.c,194 :: 		}
L_end_goRight:
	RETURN
; end of _goRight

_goLeft:

;AvoidoFinal.c,197 :: 		void goLeft(void){
;AvoidoFinal.c,198 :: 		PORTC = 0xA0; // Enable left backward and right forward
	MOVLW      160
	MOVWF      PORTC+0
;AvoidoFinal.c,199 :: 		}
L_end_goLeft:
	RETURN
; end of _goLeft

_servoINIT:

;AvoidoFinal.c,201 :: 		void servoINIT(void){
;AvoidoFinal.c,202 :: 		TMR1H = 0x00;
	CLRF       TMR1H+0
;AvoidoFinal.c,203 :: 		TMR1L = 0x00;
	CLRF       TMR1L+0
;AvoidoFinal.c,205 :: 		HL = 1; // Start with high state
	MOVLW      1
	MOVWF      _HL+0
;AvoidoFinal.c,206 :: 		CCP1CON = 0x08; // Compare mode Set output on match
	MOVLW      8
	MOVWF      CCP1CON+0
;AvoidoFinal.c,208 :: 		T1CON = 0x01; // Timer1 On Fosc/4 (inc 0.5µs) with no prescaler
	MOVLW      1
	MOVWF      T1CON+0
;AvoidoFinal.c,210 :: 		PIE1 = PIE1 | 0x04; // Enable CCP1 interrupts
	BSF        PIE1+0, 2
;AvoidoFinal.c,212 :: 		CCPR1H = 2000 >> 8; // Initial compare value for high state
	MOVLW      7
	MOVWF      CCPR1H+0
;AvoidoFinal.c,213 :: 		CCPR1L = 2000;
	MOVLW      208
	MOVWF      CCPR1L+0
;AvoidoFinal.c,214 :: 		}
L_end_servoINIT:
	RETURN
; end of _servoINIT

_mydelay_ms:

;AvoidoFinal.c,216 :: 		void mydelay_ms(unsigned int ms) {
;AvoidoFinal.c,217 :: 		delayms = ms; // 1 overflow = 1 ms
	MOVF       FARG_mydelay_ms_ms+0, 0
	MOVWF      _delayms+0
	MOVF       FARG_mydelay_ms_ms+1, 0
	MOVWF      _delayms+1
;AvoidoFinal.c,218 :: 		Counter = 0;                 // Reset overflow counter
	CLRF       _Counter+0
	CLRF       _Counter+1
;AvoidoFinal.c,219 :: 		while (Counter < delayms);
L_mydelay_ms29:
	MOVF       _delayms+1, 0
	SUBWF      _Counter+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__mydelay_ms50
	MOVF       _delayms+0, 0
	SUBWF      _Counter+0, 0
L__mydelay_ms50:
	BTFSC      STATUS+0, 0
	GOTO       L_mydelay_ms30
	GOTO       L_mydelay_ms29
L_mydelay_ms30:
;AvoidoFinal.c,220 :: 		}
L_end_mydelay_ms:
	RETURN
; end of _mydelay_ms

_delay10us:

;AvoidoFinal.c,222 :: 		void delay10us(void){
;AvoidoFinal.c,224 :: 		for(i = 0; i < 10; i++){
	CLRF       R1+0
L_delay10us31:
	MOVLW      10
	SUBWF      R1+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_delay10us32
;AvoidoFinal.c,225 :: 		asm NOP;
	NOP
;AvoidoFinal.c,226 :: 		asm NOP;
	NOP
;AvoidoFinal.c,224 :: 		for(i = 0; i < 10; i++){
	INCF       R1+0, 1
;AvoidoFinal.c,227 :: 		}
	GOTO       L_delay10us31
L_delay10us32:
;AvoidoFinal.c,228 :: 		}
L_end_delay10us:
	RETURN
; end of _delay10us
