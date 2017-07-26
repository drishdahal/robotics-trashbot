/* Trash collecting/ Line following robot TrashBot coded using Arduino. Programmed by Drishya and Joseph at RAM Lab UTSA/*

#include <AFMotor.h>
#include<Wire.h>
#include <QTRSensors.h>
#define NUM_SENSORS 8// number of sensors used
#define NUM_SAMPLES_PER_SENSOR 4// average 4
analog samples per sensor reading
#define EMITTER_PIN A11
// sensors 0 through 5 are connected to analog inputs 0
through 5, respectively
QTRSensorsAnalog qtra((unsigned char[]) {A8, A9, A10,
A11, A12, A13, A7, A15}, NUM_SENSORS,
NUM_SAMPLES_PER_SENSOR, EMITTER_PIN);
unsigned int sensorValues[NUM_SENSORS];
AF_DCMotor right_motor(2);
AF_DCMotor left_motor(3);
const int trigPin = 43;
const int echoPin = 45;
long duration;
int distance;
void setup(){
delay(500);
int i;
pinMode(trigPin, OUTPUT);
pinMode(echoPin, INPUT);
pinMode(47, OUTPUT); //LED
digitalWrite(47, HIGH);
for (i = 0; i < 200; i++) // make the calibration take about
5 seconds
{
qtra.calibrate(); // reads all sensors 10 times at 2.5
ms per six sensors (i.e. ~25 ms per call)
delay(20);
}
// print the calibration minimum values measured when
emitters were on
Serial.begin(9600);
digitalWrite(47, LOW);
for (i = 0; i < NUM_SENSORS; i++)
{
Serial.print(qtra.calibratedMinimumOn[i]);
Serial.print(' ');
}
Serial.println();
// print the calibration maximum values measured when
emitters were on
for (i = 0; i < NUM_SENSORS; i++)
{
Serial.print(qtra.calibratedMaximumOn[i]);
Serial.print(' ');
}
Serial.println();
Serial.println();
delay(1000);
}
void loop()
{
digitalWrite(trigPin, LOW); //Clears the trigPin
delay(2);
digitalWrite(trigPin, HIGH); //sets the trigPin on HIGH
for 10 microseconds
delay(10);
digitalWrite(trigPin, LOW);
duration = pulseIn(echoPin, HIGH); //Reads the
echoPin, returns the sound wave travel time in
microseconds
distance = duration*0.034/2; //cm
//Serial.print("Distance: ");
//Serial.println(distance); //End of Ultrasonic
Sensor portion
qtra.read(sensorValues);
unsigned char i;
for (i = 0; i < NUM_SENSORS; i++)
{
Serial.print(sensorValues[i]);
Serial.print(' ');
}
Serial.println(" ");
delay(25);
movement();
}
int x = 1;
if (distance <= 10)
{
right_motor.run(RELEASE);
left_motor.run(RELEASE);
Serial.println("Stop!");
}
else if((sensorValues[0,1,2,5,6,7]
<=450)&&(sensorValues[4] >=500)) //can do ! statement
here as well
{
right_motor.setSpeed(190*x);
left_motor.setSpeed(190*x);
Serial.println("Forward!");
right_motor.run(FORWARD);
left_motor.run(FORWARD);
delay(200);
}
else if ((sensorValues[0,1,2,4]
<=450)&&((sensorValues[7,6] >=500) ||
(sensorValues[6,5] >= 500) || (sensorValues[5] >= 500) ||
(sensorValues[5] >= 500) || (sensorValues[7] >= 500)))
{
right_motor.run(RELEASE);
Serial.println("Turn Right");
left_motor.setSpeed(160*x);
left_motor.run(FORWARD);
delay(160);
}
else if ((sensorValues[0,1,2] <=450)&&(sensorValues[4]
>= 450))
{
right_motor.run(RELEASE);
Serial.println("Turn Slightly Right");
left_motor.setSpeed(160*x);
left_motor.run(FORWARD);
delay(160);
}
else if ((sensorValues[7,6,5,4] <=
450)&&((sensorValues[0] >=500) || (sensorValues[1,0] >=
500)) ||(sensorValues[2,1] >= 500) || (sensorValues[2] >=
590))
{
left_motor.run(RELEASE);
Serial.println("Turn Left");
right_motor.setSpeed(160*x);
right_motor.run(FORWARD);
delay(160);
}
else if (sensorValues[0,1,2,4,5,6,7] <= 500)
{
Serial.print("Backward");
right_motor.setSpeed(190*x);
left_motor.setSpeed(190*x);
right_motor.run(BACKWARD);
left_motor.run(BACKWARD);
delay(200);
}
else
{
Serial.print("Nothing");
right_motor.run(RELEASE);
left_motor.run(RELEASE);
}
}