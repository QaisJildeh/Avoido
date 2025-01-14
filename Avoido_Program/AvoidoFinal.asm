
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;AvoidoFinal.c,30 :: 		void interrupt(void){
;AvoidoFinal.c,31 :: 		if(INTCON & 0x02){ // Check for external interrupt
	BTFSS      INTCON+0, 1
	GOTO       L_interrupt0
;AvoidoFinal.c,32 :: 		PORTC = PORTC & 0x0F;
	MOVLW      15
	ANDWF      PORTC+0, 1
;AvoidoFinal.c,33 :: 		while(!(PORTB & 0x01)){
L_interrupt1:
	BTFSC      PORTB+0, 0
	GOTO       L_interrupt2
;AvoidoFinal.c,34 :: 		PORTA = PORTA | 0x06;
	MOVLW      6
	IORWF      PORTA+0, 1
;AvoidoFinal.c,36 :: 		mydelay_ms(500);
	MOVLW      244
	MOVWF      FARG_mydelay_ms+0
	MOVLW      1
	MOVWF      FARG_mydelay_ms+1
	CALL       _mydelay_ms+0
;AvoidoFinal.c,37 :: 		PORTA = PORTA & 0xF9;
	MOVLW      249
	ANDWF      PORTA+0, 1
;AvoidoFinal.c,39 :: 		mydelay_ms(500);
	MOVLW      244
	MOVWF      FARG_mydelay_ms+0
	MOVLW      1
	MOVWF      FARG_mydelay_ms+1
	CALL       _mydelay_ms+0
;AvoidoFinal.c,40 :: 		}
	GOTO       L_interrupt1
L_interrupt2:
;AvoidoFinal.c,41 :: 		PORTA = PORTA | 0x02;
	BSF        PORTA+0, 1
;AvoidoFinal.c,42 :: 		PORTA = PORTA & 0x03;
	MOVLW      3
	ANDWF      PORTA+0, 1
;AvoidoFinal.c,43 :: 		INTCON = INTCON & 0xFD;
	MOVLW      253
	ANDWF      INTCON+0, 1
;AvoidoFinal.c,44 :: 		}
L_interrupt0:
;AvoidoFinal.c,47 :: 		if (INTCON & 0x04) {  // Timer0 overflow
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt3
;AvoidoFinal.c,48 :: 		Counter++;
	INCF       _Counter+0, 1
	BTFSC      STATUS+0, 2
	INCF       _Counter+1, 1
;AvoidoFinal.c,49 :: 		INTCON = INTCON & 0xFB; // Clear the Timer0 overflow flag
	MOVLW      251
	ANDWF      INTCON+0, 1
;AvoidoFinal.c,50 :: 		TMR0 = 236;             // Reset Timer0 for the next overflow
	MOVLW      236
	MOVWF      TMR0+0
;AvoidoFinal.c,51 :: 		}
	GOTO       L_interrupt4
L_interrupt3:
;AvoidoFinal.c,56 :: 		else if(PIR1 & 0x04) { // CCP1 interrupt
	BTFSS      PIR1+0, 2
	GOTO       L_interrupt5
;AvoidoFinal.c,57 :: 		if(!HL){ // High state
	MOVF       _HL+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt6
;AvoidoFinal.c,58 :: 		CCPR1H = angle >> 8;
	CLRF       CCPR1H+0
;AvoidoFinal.c,59 :: 		CCPR1L = angle;
	MOVF       _angle+0, 0
	MOVWF      CCPR1L+0
;AvoidoFinal.c,60 :: 		HL = 0; // Switch to low state
	CLRF       _HL+0
;AvoidoFinal.c,61 :: 		CCP1CON = 0x09; // Compare mode, clear output on match
	MOVLW      9
	MOVWF      CCP1CON+0
;AvoidoFinal.c,62 :: 		}
	GOTO       L_interrupt7
L_interrupt6:
;AvoidoFinal.c,64 :: 		CCPR1H = (40000 - angle) >> 8; // Calculate low state duration
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
;AvoidoFinal.c,65 :: 		CCPR1L = (40000 - angle);
	MOVF       R3+0, 0
	MOVWF      CCPR1L+0
;AvoidoFinal.c,66 :: 		CCP1CON = 0x08; // Compare mode, set output on match
	MOVLW      8
	MOVWF      CCP1CON+0
;AvoidoFinal.c,67 :: 		HL = 1; // Switch to high state
	MOVLW      1
	MOVWF      _HL+0
;AvoidoFinal.c,68 :: 		}
L_interrupt7:
;AvoidoFinal.c,69 :: 		TMR1H = 0x00;
	CLRF       TMR1H+0
;AvoidoFinal.c,70 :: 		TMR1L = 0x00;
	CLRF       TMR1L+0
;AvoidoFinal.c,71 :: 		PIR1 = PIR1 & 0xFB; // Clear CCP1 interrupt flag
	MOVLW      251
	ANDWF      PIR1+0, 1
;AvoidoFinal.c,72 :: 		}
	GOTO       L_interrupt8
L_interrupt5:
;AvoidoFinal.c,73 :: 		else {INTCON = 0xF0;} // Any other interrupts are not allowed
	MOVLW      240
	MOVWF      INTCON+0
L_interrupt8:
L_interrupt4:
;AvoidoFinal.c,74 :: 		}
L_end_interrupt:
L__interrupt33:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;AvoidoFinal.c,77 :: 		void main(void){
;AvoidoFinal.c,78 :: 		TRISA = 0x01; // A0 only analog input, everything else is a digital output
	MOVLW      1
	MOVWF      TRISA+0
;AvoidoFinal.c,79 :: 		TRISB = 0x01; // RB0 input for interrupt
	MOVLW      1
	MOVWF      TRISB+0
;AvoidoFinal.c,80 :: 		TRISC = 0x00; // Port C all outputs, RC1 --> PWM for H-Bridge, RC2 --> Compare for Servo Motor
	CLRF       TRISC+0
;AvoidoFinal.c,81 :: 		TRISD = 0x15; // D0 --> D5 for ultrasonic sensor
	MOVLW      21
	MOVWF      TRISD+0
;AvoidoFinal.c,82 :: 		TRISE = 0x00; // Unimplemented
	CLRF       TRISE+0
;AvoidoFinal.c,84 :: 		PORTA = PORTA | 0x02;
	BSF        PORTA+0, 1
;AvoidoFinal.c,85 :: 		PORTA = PORTA & 0xFB;
	MOVLW      251
	ANDWF      PORTA+0, 1
;AvoidoFinal.c,87 :: 		OPTION_REG = 0x80;
	MOVLW      128
	MOVWF      OPTION_REG+0
;AvoidoFinal.c,88 :: 		INTCON = 0xF0;
	MOVLW      240
	MOVWF      INTCON+0
;AvoidoFinal.c,91 :: 		ADCinit();
	CALL       _ADCinit+0
;AvoidoFinal.c,92 :: 		initPWM();
	CALL       _initPWM+0
;AvoidoFinal.c,93 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;AvoidoFinal.c,94 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;AvoidoFinal.c,97 :: 		HL = 1; // Start with high state
	MOVLW      1
	MOVWF      _HL+0
;AvoidoFinal.c,98 :: 		CCP1CON = 0x08; // Compare mode, set output on match
	MOVLW      8
	MOVWF      CCP1CON+0
;AvoidoFinal.c,101 :: 		T1CON = 0x01; // Timer1 On Fosc/4 (inc 0.5µs) with no prescaler
	MOVLW      1
	MOVWF      T1CON+0
;AvoidoFinal.c,105 :: 		PIE1 |= 0x04; // Enable CCP1 interrupts
	BSF        PIE1+0, 2
;AvoidoFinal.c,108 :: 		CCPR1H = 2000 >> 8; // Initial compare value for high state
	MOVLW      7
	MOVWF      CCPR1H+0
;AvoidoFinal.c,109 :: 		CCPR1L = 2000;
	MOVLW      208
	MOVWF      CCPR1L+0
;AvoidoFinal.c,114 :: 		while(1){
L_main9:
;AvoidoFinal.c,116 :: 		middleSensor = calculate_distance(0)/10;
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
;AvoidoFinal.c,117 :: 		rightSensor = calculate_distance(1)/10;
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
;AvoidoFinal.c,118 :: 		leftSensor = calculate_distance(2)/10;
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
;AvoidoFinal.c,122 :: 		if(middleSensor >= 2) {goForward();}
	MOVLW      0
	SUBWF      _middleSensor+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main35
	MOVLW      2
	SUBWF      _middleSensor+0, 0
L__main35:
	BTFSS      STATUS+0, 0
	GOTO       L_main11
	CALL       _goForward+0
	GOTO       L_main12
L_main11:
;AvoidoFinal.c,123 :: 		else if(rightSensor >= 2) {goRight();}
	MOVLW      0
	SUBWF      _rightSensor+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main36
	MOVLW      2
	SUBWF      _rightSensor+0, 0
L__main36:
	BTFSS      STATUS+0, 0
	GOTO       L_main13
	CALL       _goRight+0
	GOTO       L_main14
L_main13:
;AvoidoFinal.c,124 :: 		else if(leftSensor >= 2) {goLeft();}
	MOVLW      0
	SUBWF      _leftSensor+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main37
	MOVLW      2
	SUBWF      _leftSensor+0, 0
L__main37:
	BTFSS      STATUS+0, 0
	GOTO       L_main15
	CALL       _goLeft+0
	GOTO       L_main16
L_main15:
;AvoidoFinal.c,125 :: 		else{goRight();}    // Keep turing right (counter clockwise in position) until front is clear
	CALL       _goRight+0
L_main16:
L_main14:
L_main12:
;AvoidoFinal.c,129 :: 		lightIntensity = ADCread();
	CALL       _ADCread+0
	MOVF       R0+0, 0
	MOVWF      _lightIntensity+0
	MOVF       R0+1, 0
	MOVWF      _lightIntensity+1
;AvoidoFinal.c,131 :: 		if(lightIntensity > 818){  // 1KOhm, ~4.0V  && previousState
	MOVF       R0+1, 0
	SUBLW      3
	BTFSS      STATUS+0, 2
	GOTO       L__main38
	MOVF       R0+0, 0
	SUBLW      50
L__main38:
	BTFSC      STATUS+0, 0
	GOTO       L_main17
;AvoidoFinal.c,132 :: 		previousState = 0;
	CLRF       _previousState+0
;AvoidoFinal.c,133 :: 		PORTA = PORTA & 0x01;   // Turn on LEDs ==> 0
	MOVLW      1
	ANDWF      PORTA+0, 1
;AvoidoFinal.c,134 :: 		angle = 1000; // Set angle to 0 degrees
	MOVLW      232
	MOVWF      _angle+0
;AvoidoFinal.c,135 :: 		}
	GOTO       L_main18
L_main17:
;AvoidoFinal.c,137 :: 		previousState = 1;
	MOVLW      1
	MOVWF      _previousState+0
;AvoidoFinal.c,138 :: 		PORTA = PORTA | 0x02;   // Turn off LEDs ==> 1
	BSF        PORTA+0, 1
;AvoidoFinal.c,139 :: 		angle = 3100; // Set angle to 0 degrees
	MOVLW      28
	MOVWF      _angle+0
;AvoidoFinal.c,140 :: 		}
L_main18:
;AvoidoFinal.c,143 :: 		}
	GOTO       L_main9
;AvoidoFinal.c,144 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_ADCinit:

;AvoidoFinal.c,147 :: 		void ADCinit(void){
;AvoidoFinal.c,148 :: 		ADCON0 = 0x41;  // ATD ON, Don't GO, Channel 0, Fosc/16
	MOVLW      65
	MOVWF      ADCON0+0
;AvoidoFinal.c,149 :: 		ADCON1 = 0xCE;  // All channels are Digital except RA0/AN0 is Analog, 500 KHz, right justified
	MOVLW      206
	MOVWF      ADCON1+0
;AvoidoFinal.c,150 :: 		}
L_end_ADCinit:
	RETURN
; end of _ADCinit

_ADCread:

;AvoidoFinal.c,153 :: 		unsigned int ADCread(void){
;AvoidoFinal.c,154 :: 		ADCON0 = ADCON0 | 0x04; // GO
	BSF        ADCON0+0, 2
;AvoidoFinal.c,155 :: 		while(ADCON0 & 0x04);
L_ADCread19:
	BTFSS      ADCON0+0, 2
	GOTO       L_ADCread20
	GOTO       L_ADCread19
L_ADCread20:
;AvoidoFinal.c,158 :: 		return ((ADRESH << 8) | ADRESL);
	MOVF       ADRESH+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       ADRESL+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
;AvoidoFinal.c,159 :: 		}
L_end_ADCread:
	RETURN
; end of _ADCread

_calculate_distance:

;AvoidoFinal.c,163 :: 		unsigned int calculate_distance(char sensorNumber){
;AvoidoFinal.c,164 :: 		unsigned int time = 0, distance;
;AvoidoFinal.c,165 :: 		unsigned char triggerPin = 0, echoPin = 0; // Initialize to prevent undefined behavior
	CLRF       calculate_distance_triggerPin_L0+0
	CLRF       calculate_distance_echoPin_L0+0
;AvoidoFinal.c,169 :: 		if(sensorNumber == 0){
	MOVF       FARG_calculate_distance_sensorNumber+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_calculate_distance21
;AvoidoFinal.c,170 :: 		triggerPin = 0x02;
	MOVLW      2
	MOVWF      calculate_distance_triggerPin_L0+0
;AvoidoFinal.c,171 :: 		echoPin = 0x01;
	MOVLW      1
	MOVWF      calculate_distance_echoPin_L0+0
;AvoidoFinal.c,172 :: 		}
	GOTO       L_calculate_distance22
L_calculate_distance21:
;AvoidoFinal.c,173 :: 		else if(sensorNumber == 1){
	MOVF       FARG_calculate_distance_sensorNumber+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_calculate_distance23
;AvoidoFinal.c,174 :: 		triggerPin = 0x08;
	MOVLW      8
	MOVWF      calculate_distance_triggerPin_L0+0
;AvoidoFinal.c,175 :: 		echoPin = 0x04;
	MOVLW      4
	MOVWF      calculate_distance_echoPin_L0+0
;AvoidoFinal.c,176 :: 		}
	GOTO       L_calculate_distance24
L_calculate_distance23:
;AvoidoFinal.c,178 :: 		triggerPin = 0x20;
	MOVLW      32
	MOVWF      calculate_distance_triggerPin_L0+0
;AvoidoFinal.c,179 :: 		echoPin = 0x10;
	MOVLW      16
	MOVWF      calculate_distance_echoPin_L0+0
;AvoidoFinal.c,180 :: 		}
L_calculate_distance24:
L_calculate_distance22:
;AvoidoFinal.c,184 :: 		PORTD = PORTD | triggerPin; // Set trigger pin HIGH
	MOVF       calculate_distance_triggerPin_L0+0, 0
	IORWF      PORTD+0, 1
;AvoidoFinal.c,185 :: 		Delay_us(10);        // Wait for 10 microseconds
	MOVLW      6
	MOVWF      R13+0
L_calculate_distance25:
	DECFSZ     R13+0, 1
	GOTO       L_calculate_distance25
	NOP
;AvoidoFinal.c,186 :: 		PORTD = PORTD & ~triggerPin; // Set trigger pin LOW
	COMF       calculate_distance_triggerPin_L0+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	ANDWF      PORTD+0, 1
;AvoidoFinal.c,190 :: 		while (!(PORTD & echoPin)); // Wait until echo pin goes HIGH
L_calculate_distance26:
	MOVF       calculate_distance_echoPin_L0+0, 0
	ANDWF      PORTD+0, 0
	MOVWF      R0+0
	BTFSS      STATUS+0, 2
	GOTO       L_calculate_distance27
	GOTO       L_calculate_distance26
L_calculate_distance27:
;AvoidoFinal.c,194 :: 		TMR1H = 0;
	CLRF       TMR1H+0
;AvoidoFinal.c,195 :: 		TMR1L = 0;
	CLRF       TMR1L+0
;AvoidoFinal.c,199 :: 		T1CON = 0x01;
	MOVLW      1
	MOVWF      T1CON+0
;AvoidoFinal.c,203 :: 		while (PORTD & echoPin); // Wait until echo pin goes LOW
L_calculate_distance28:
	MOVF       calculate_distance_echoPin_L0+0, 0
	ANDWF      PORTD+0, 0
	MOVWF      R0+0
	BTFSC      STATUS+0, 2
	GOTO       L_calculate_distance29
	GOTO       L_calculate_distance28
L_calculate_distance29:
;AvoidoFinal.c,207 :: 		T1CON = 0x00;
	CLRF       T1CON+0
;AvoidoFinal.c,211 :: 		time = (TMR1H << 8) | TMR1L;
	MOVF       TMR1H+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       TMR1L+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
;AvoidoFinal.c,215 :: 		distance = time / 58.82; // Distance in cm
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
;AvoidoFinal.c,218 :: 		return distance; // Return Distance
;AvoidoFinal.c,219 :: 		}
L_end_calculate_distance:
	RETURN
; end of _calculate_distance

_initPWM:

;AvoidoFinal.c,222 :: 		void initPWM(void){
;AvoidoFinal.c,223 :: 		PORTB = 0x00;
	CLRF       PORTB+0
;AvoidoFinal.c,224 :: 		T2CON = 0x07; // Turn on Timer 2 + Prescaler 1:16
	MOVLW      7
	MOVWF      T2CON+0
;AvoidoFinal.c,225 :: 		CCP2CON = 0x0C; // Two LSBs of duty cycle
	MOVLW      12
	MOVWF      CCP2CON+0
;AvoidoFinal.c,226 :: 		PR2 = 0xFA; // ==> 0.5x10^-6 x 250 x 16 = 2ms
	MOVLW      250
	MOVWF      PR2+0
;AvoidoFinal.c,227 :: 		CCPR2L = 0x7D; // 50% PWM
	MOVLW      125
	MOVWF      CCPR2L+0
;AvoidoFinal.c,228 :: 		}
L_end_initPWM:
	RETURN
; end of _initPWM

_goForward:

;AvoidoFinal.c,232 :: 		void goForward(void){
;AvoidoFinal.c,233 :: 		PORTC = 0x90; // Enable left and right forward
	MOVLW      144
	MOVWF      PORTC+0
;AvoidoFinal.c,234 :: 		}
L_end_goForward:
	RETURN
; end of _goForward

_goRight:

;AvoidoFinal.c,238 :: 		void goRight(void){
;AvoidoFinal.c,239 :: 		PORTC = 0x50; // Enable right backward and left forward
	MOVLW      80
	MOVWF      PORTC+0
;AvoidoFinal.c,240 :: 		}
L_end_goRight:
	RETURN
; end of _goRight

_goLeft:

;AvoidoFinal.c,244 :: 		void goLeft(void){
;AvoidoFinal.c,245 :: 		PORTC = 0xA0; // Enable left backward and right forward
	MOVLW      160
	MOVWF      PORTC+0
;AvoidoFinal.c,246 :: 		}
L_end_goLeft:
	RETURN
; end of _goLeft

_servoINIT:

;AvoidoFinal.c,249 :: 		void servoINIT(void){
;AvoidoFinal.c,250 :: 		TMR1H = 0x00;
	CLRF       TMR1H+0
;AvoidoFinal.c,251 :: 		TMR1L = 0x00;
	CLRF       TMR1L+0
;AvoidoFinal.c,254 :: 		HL = 1; // Start with high state
	MOVLW      1
	MOVWF      _HL+0
;AvoidoFinal.c,255 :: 		CCP1CON = 0x08; // Compare mode Set output on match
	MOVLW      8
	MOVWF      CCP1CON+0
;AvoidoFinal.c,258 :: 		T1CON = 0x01; // Timer1 On Fosc/4 (inc 0.5µs) with no prescaler
	MOVLW      1
	MOVWF      T1CON+0
;AvoidoFinal.c,261 :: 		PIE1 = PIE1 | 0x04; // Enable CCP1 interrupts
	BSF        PIE1+0, 2
;AvoidoFinal.c,264 :: 		CCPR1H = 2000 >> 8; // Initial compare value for high state
	MOVLW      7
	MOVWF      CCPR1H+0
;AvoidoFinal.c,265 :: 		CCPR1L = 2000;
	MOVLW      208
	MOVWF      CCPR1L+0
;AvoidoFinal.c,266 :: 		}
L_end_servoINIT:
	RETURN
; end of _servoINIT

_mydelay_ms:

;AvoidoFinal.c,270 :: 		void mydelay_ms(unsigned int ms) {
;AvoidoFinal.c,271 :: 		delayms = ms; // 1 overflow = 1 ms
	MOVF       FARG_mydelay_ms_ms+0, 0
	MOVWF      _delayms+0
	MOVF       FARG_mydelay_ms_ms+1, 0
	MOVWF      _delayms+1
;AvoidoFinal.c,272 :: 		Counter = 0;                 // Reset overflow counter
	CLRF       _Counter+0
	CLRF       _Counter+1
;AvoidoFinal.c,273 :: 		while (timer < delayms);
L_mydelay_ms30:
	MOVF       _delayms+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__mydelay_ms48
	MOVF       _delayms+0, 0
	SUBWF      _timer+0, 0
L__mydelay_ms48:
	BTFSC      STATUS+0, 0
	GOTO       L_mydelay_ms31
	GOTO       L_mydelay_ms30
L_mydelay_ms31:
;AvoidoFinal.c,274 :: 		}
L_end_mydelay_ms:
	RETURN
; end of _mydelay_ms
