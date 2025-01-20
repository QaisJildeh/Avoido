# Avoido – Obstacle Avoidance Robot

Avoido is an autonomous obstacle-avoiding robot designed using the PIC16F877A microcontroller. The robot uses ultrasonic sensors for real-time obstacle detection, integrates DC motors for smooth navigation, and includes additional features like light intensity detection, audible alerts, and interrupt-based tasks to enhance functionality.

Table of Contents

Introduction

Objectives

Features

Hardware Components

System Design

Pin Connections

Software Design

How to Use

Problems and Recommendations

Conclusion

References

Introduction

Avoido is a project that demonstrates the principles of embedded systems in robotics. Using ultrasonic sensors for obstacle detection and IR sensors for interrupt-based tasks, the robot achieves efficient mobility and real-time responsiveness. It integrates multiple peripherals like LEDs, buzzers, and DC motors for a complete embedded system solution. Potential applications include warehouse automation and search-and-rescue operations.

Objectives

Utilize analog and digital inputs for obstacle detection.

Implement PWM-driven motor control for precise movements.

Develop interrupt- and timer-based tasks for responsive actions.

Ensure efficient integration of sensors and peripherals.

Achieve reliable obstacle avoidance and smooth navigation.

Features

Obstacle Detection: Real-time avoidance using three ultrasonic sensors.

Motor Control: Directional control using an H-Bridge and PWM.

Interrupt Tasks: IR sensor-based tasks for quick response to obstacles.

Light Detection: LDR for light intensity detection with automatic LED control.

User Interface: Indicators using LEDs and audible alerts via a buzzer.

Power Management: Integrated power switch and reset button for ease of control.

Hardware Components

Microcontroller: PIC16F877A

Sensors: HC-SR04 ultrasonic sensors, IR sensor, and LDR

Actuators: DC motors (with H-Bridge) and servo motor

Indicators: LEDs and buzzer

Power Supply: Voltage regulator and battery

System Design

Pin Connections

Pin

Port

Use

RA0

LDR

Analog Input

RA1

LEDs

Digital Output

RA2

Buzzer

Digital Output

RC0

H-Bridge Enable

PWM Output

RD0-D5

Ultrasonic Sensors

Trigger/Echo

RB0

IR Sensor

External Interrupt

For a detailed pin mapping, refer to the project report.

Software Design

The software for Avoido is modular and includes:

Sensor Control: Functions to calculate distances using ultrasonic sensors.

Motor Control: Functions for forward, left, and right movements.

Light Detection: Functions to control LEDs based on LDR readings.

Interrupts: Handling external interrupts for IR-based obstacle detection.

PWM Initialization: For motor speed and direction control.

How to Use

Setup Hardware: Assemble the hardware components as per the pin connections.

Power On: Switch on the power and ensure the system initializes.

Operation: Place the robot in an environment with obstacles. The robot will detect obstacles, avoid them, and navigate smoothly.

Debugging: Use LEDs and buzzer signals to monitor the robot’s state.

Problems and Recommendations

Startup Brownouts: Add capacitors to stabilize the voltage regulator.

Code Debugging: Test and debug small modules incrementally.

Power Overload: Use external drivers or a microcontroller with higher current capacity.

Timer Conflicts: Consider additional timers or software-based delays.

Conclusion

Avoido successfully demonstrates an autonomous obstacle-avoiding robot. With real-time obstacle detection, smooth navigation, and responsive behavior, it serves as a robust prototype for autonomous robotics. Future enhancements could include advanced pathfinding algorithms and additional sensors for broader functionality.

References

PIC16F877A Datasheet

Designing Embedded Systems with PIC Microcontrollers: Principles and Applications, Tim Wilmshurst (2nd edition, 2009)
