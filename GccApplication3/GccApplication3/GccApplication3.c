/********************************************************************************
 Platform: SPARK V
 Experiment: 4_Motion_Control_Simple
 Written by: Vinod Desai, NEX Robotics Pvt. Ltd.
 Edited By: Sachitanand Malewar, NEX Robotics Pvt. Ltd.
 Last Modification: 22nd September 2010
 AVR Studio Version 4.17, Build 666

 Concepts covered: I/O interfacing, motion control using L293D 

 This experiment demonstrates simple motion control using L293D Motor driver IC.

 There are two components to the motion control:
 1. Direction control using pins PORTB0 to 	PORTB3
 2. Velocity control using Pulse Width Modulation(PWM) on pins PD4 and PD5.

 Pulse width modulation is a process in which duty cycle of constant frequency square wave is modulated to 
 control power delivered to the load i.e. motor. 

 In this experiment for the simplicity PWM pins, PD4 and PD5 are kept at logic 1.
 Use of PWM will be covered in the "5_Velocity_Control_Using_PWM" experiment.
   
 Connection Details:  	L-1---->PB0;		L-2---->PB1;
   						R-1---->PB2;		R-2---->PB3;
   						PD4 (OC1B) ----> Logic 1; 	PD5 (OC1A) ----> Logic 1; 

 Make sure that motors are connected to onboard motor connectors.
 
 For more detail refer to hardware and software manual

 Note: 
 
 1. Make sure that in the configuration options following settings are 
 	done for proper operation of the code

 	Microcontroller: atmega16
 	Frequency: 7372800Hz
 	Optimization: -O0 (For more information read section: Selecting proper 
	              optimization options below figure 4.22 in the hardware manual)

*********************************************************************************/

/********************************************************************************

   Copyright (c) 2010, NEX Robotics Pvt. Ltd.                       -*- c -*-
   All rights reserved.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions are met:

   * Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.

   * Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in
     the documentation and/or other materials provided with the
     distribution.

   * Neither the name of the copyright holders nor the names of
     contributors may be used to endorse or promote products derived
     from this software without specific prior written permission.

   * Source code can be used for academic purpose. 
	 For commercial use permission form the author needs to be taken.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  POSSIBILITY OF SUCH DAMAGE. 

  Software released under Creative Commence cc by-nc-sa licence.
  For legal information refer to: 
  http://creativecommons.org/licenses/by-nc-sa/3.0/legalcode


********************************************************************************/

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

void motion_pin_config (void)
{
 DDRB = DDRB | 0x0F;   //set direction of the PORTB3 to PORTB0 pins as output
 PORTB = PORTB & 0xF0; // set initial value of the PORTB3 to PORTB0 pins to logic 0
 DDRD = DDRD | 0x30;   //Setting PD4 and PD5 pins as output for PWM generation
 PORTD = PORTD | 0x30; //PD4 and PD5 pins are for velocity control using PWM
}

//Function to initialize ports
void port_init()
{
 motion_pin_config();
}

//Function used for setting motor's direction
void motion_set (unsigned char Direction)
{
 unsigned char PortBRestore = 0;

 Direction &= 0x0F; 			// removing upper nibbel as it is not needed
 PortBRestore = PORTB; 			// reading the PORTB's original status
 PortBRestore &= 0xF0; 			// setting lower direction nibbel to 0
 PortBRestore |= Direction; 	// adding lower nibbel for direction command and restoring the PORTB status
 PORTB = PortBRestore; 			// setting the command to the port
}

void forward (void)         //both wheels forward
{
  motion_set(0x06);
}

void back (void)            //both wheels backward
{
  motion_set(0x09);
}

void left (void)            //Left wheel backward, Right wheel forward
{
  motion_set(0x05);
}

void right (void)           //Left wheel forward, Right wheel backward
{   
  motion_set(0x0A);
}

void soft_left (void)       //Left wheel stationary, Right wheel forward
{
 motion_set(0x04);
}

void soft_right (void)      //Left wheel forward, Right wheel is stationary
{ 
 motion_set(0x02);
}

void soft_left_2 (void)     //Left wheel backward, right wheel stationary
{
 motion_set(0x01);
}

void soft_right_2 (void)    //Left wheel stationary, Right wheel backward
{
 motion_set(0x08);
}

void hard_stop (void)       //hard stop(stop suddenly)
{
  motion_set(0x00);
}

void soft_stop (void)       //soft stop(stops solowly)
{
  motion_set(0x0F);
}

//Function to configure the ADC pins
void adc_pin_config(void)
{
	DDRA = 0x00; // set PORTA as input
	PORTA = 0x00; // set PORTA pins floating
}

//Function to Initialize ADC
void adc_init()
{
	ADCSRA = 0x00;
	ADMUX = 0x20; //Vref=5V external --- ADLAR=1 --- MUX4:0 = 0000
	ACSR = 0x80;
	ADCSRA = 0x86; //ADEN=1 --- ADIE=1 --- ADPS2:0 = 1 1 0
}

void init_devices (void)
{
 cli(); //Clears the global interrupts
 port_init();
 adc_init();	
 sei(); //Enables the global interrupts
}

//This Function accepts the Channel Number and returns the corresponding Analog Value
unsigned char ADC_Conversion(unsigned char Ch)
{
	unsigned char a;
	Ch = Ch & 0x07;
	ADMUX= 0x20| Ch;
	ADCSRA = ADCSRA | 0x40; //Set start conversion bit
	while((ADCSRA&0x10)==0); //Wait for ADC conversion to complete
	a=ADCH;
	ADCSRA = ADCSRA|0x10; //clear ADIF (ADC Interrupt Flag) by writing 1 to it
	ADCSRB = 0x00;
	return a;
}

int pid_control(int l, int m, int r)
{
	float kp = 6, kd = 8, ki = 0.001;
	error = ggggvhvbfgfvbvvcbcbvccvzxdd
}

//Main Function
int main()
{
	init_devices();
	int left_sensor, right_sensor, middle_sensor, threshold_low = 40, threshold_high = 200;
	
	while(1)
	{
		
		left_sensor = int(ADC_Conversion(3));
		middle_sensor = int(ADC_Conversion(4));
		right_sensor = int(ADC_Conversion(5));
		float a_l = 1, a_m = 1, a_r = 1;
		float measure;
		//[0 1 1]
		if(left_sensor < threshold_low  && middle_sensor > threshold_high && right_sensor > threshold_high)
		{
			measure = (left_sensor - threshold_low)*a_l + (middle_sensor - threshold_high)*a_m + (right_sensor - threshold_high)*a_r;
			soft_right();
			delay(200);	
		}
		//[1 1 0]
		else if(left_sensor > threshold_high && middle_sensor > threshold_high && right_sensor < threshold_low)
		{
			measure = (left_sensor - threshold_high)*a_l + (middle_sensor - threshold_high)*a_m + (right_sensor - threshold_low)*a_r;
			soft_left();
			delay(200);
		}
		//[0 0 1]
		else if(left_sensor < threshold_low && middle_sensor < threshold_low && right_sensor > threshold_high) 
		{
			measure = (left_sensor - threshold_low)*a_l + (middle_sensor - threshold_low)*a_m + (right_sensor - threshold_high)*a_r;
			right();
			delay(200);
		}
		//[1 0 0]
		else if(left_sensor > threshold_high && middle_sensor < threshold_low && right_sensor < threshold_low)
		{
			measure = (left_sensor - threshold_high)*a_l + (middle_sensor - threshold_low)*a_m + (right_sensor -threshold_low)*a_r;
			left();
			delay(200);
		}
		//[1 1 1]
		else if(left_sensor > threshold_high && middle_sensor > threshold_high && right_sensor > threshold_high)
		{
			measure = (left_sensor - threshold_high)*a_l + (middle_sensor - threshold_high)*a_m + (right_sensor - threshold_high)*a_r;
			forward();
			delay(200);
		}	
		
		/*forward();            //both wheels forward
		_delay_ms(1000);

		hard_stop();						
		_delay_ms(300);

		back();               //both wheels backward						
		_delay_ms(1000);

		hard_stop();						
		_delay_ms(300);
	
		left();               //Left wheel backward, Right wheel forward
		_delay_ms(1000);
	
		hard_stop();						
		_delay_ms(300);
	
		right();              //Left wheel forward, Right wheel backward
		_delay_ms(1000);

		hard_stop();						
		_delay_ms(300);

		soft_left();          //Left wheel stationary, Right wheel forward
		_delay_ms(1000);
	
		hard_stop();						
		_delay_ms(300);

		soft_right();         //Left wheel forward, Right wheel is stationary
		_delay_ms(1000);

		hard_stop();						
		_delay_ms(300);

		soft_left_2();        //Left wheel backward, right wheel stationary
		_delay_ms(1000);

		hard_stop();						
		_delay_ms(300);

		soft_right_2();       //Left wheel stationary, Right wheel backward
		_delay_ms(1000);

		hard_stop();						
		_delay_ms(300);*/
	}
}

