#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include "inc/hw_memmap.h"
#include "inc/hw_ints.h"
#include "driverlib/interrupt.h"
#include "driverlib/gpio.h"
#include "driverlib/sysctl.h"
#include "driverlib/interrupt.h"
#include "driverlib/rom.h"
#include "driverlib/rom_map.h"
#include "driverlib/timer.h"
#include "driverlib/sysctl.h"
#include "inc/hw_types.h"
#include "driverlib/pin_map.h"
#include "driverlib/uart.h"
#include "utils/uartstdio.h"

//#define max_clock_count 150000  //max attained
//#define timer_delay 2			//min attained
#define max_clock_count 320000 // output is 101kHz at 240000
#define timer_delay 32
#define array_length 60
#define buf_size 100


int count=0, mod_counter=0;
int output;
int val;
int inbit=0;
int array[array_length]={1,0,1,0,0,1,0,0,0,1,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,1,0,1,1,0,1,1,1,0,1,1,1,1,0};
//{1,1,0,1,0,0,0,1,0,1,0,1,1,0,0};

//{1,1,1,2,1,1,1,1,1,1};
int time_period;

int in_array[buf_size];
int i = 0;

#define max_pilot_count 400
int sending_pilot = 4;
int pilot_count = 0;

void Timer1AHandler(void);
void Timer0AHandler(void);
void Timer2AHandler(void);
void UpISR(void);
void DownISR(void);

void timer_setup()
{
	time_period = SysCtlClockGet()/(2*max_clock_count);

	SysCtlPeripheralEnable(SYSCTL_PERIPH_TIMER0); // Enable Timer 0 Clock
	TimerConfigure(TIMER0_BASE, TIMER_CFG_PERIODIC); // Configure Timer Operation as Periodic
	TimerIntRegister(TIMER0_BASE, TIMER_A, Timer0AHandler);
	TimerLoadSet(TIMER0_BASE, TIMER_A, time_period);
	TimerIntEnable(TIMER0_BASE, TIMER_TIMA_TIMEOUT);


	IntMasterEnable();
	TimerEnable(TIMER0_BASE, TIMER_A); // Start Timer 0A
}

void Timer0AHandler()
{
	TimerIntClear(TIMER0_BASE,TIMER_TIMA_TIMEOUT);
	TimerDisable(TIMER0_BASE,TIMER_A );

	if(sending_pilot == 0)
	{
		if(inbit<array_length)
		{
			if(array[inbit]==mod_counter)
			{
				GPIOPinWrite(GPIO_PORTE_BASE, GPIO_PIN_0, 0x00);
				in_array[i] = array[inbit]; i=(i+1)%buf_size;
				inbit=(inbit+ mod_counter)%array_length;

			}
			else
			{
				GPIOPinWrite(GPIO_PORTE_BASE, GPIO_PIN_0, 0x01);
				inbit=(inbit+ mod_counter)%array_length;
			}
			mod_counter =(mod_counter +1)%2;
		}

	}
	else
	{
		if(pilot_count == max_pilot_count)
		{
			sending_pilot--;
			GPIOPinWrite(GPIO_PORTE_BASE, GPIO_PIN_0, 0x00);

		}
		else
		{
			if(pilot_count%2==1)
			{
				GPIOPinWrite(GPIO_PORTE_BASE, GPIO_PIN_0, 0x01);
			}
			else
			{
				GPIOPinWrite(GPIO_PORTE_BASE, GPIO_PIN_0, 0x00);
			}
			pilot_count++;

		}

	}


	TimerLoadSet(TIMER0_BASE, TIMER_A, time_period);
	TimerIntEnable(TIMER0_BASE, TIMER_TIMA_TIMEOUT);
	TimerEnable(TIMER0_BASE, TIMER_A); // Start Timer 0A
}

void setup(void)
{
	SysCtlClockSet(SYSCTL_SYSDIV_2_5| SYSCTL_USE_PLL | SYSCTL_OSC_INT | SYSCTL_XTAL_16MHZ);
	SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOE);
	GPIOPinTypeGPIOOutput(GPIO_PORTE_BASE, GPIO_PIN_0);

	timer_setup();
}

int main(void)
{
	setup();
	while(1)
	{
	}
	return 0;
}
void SysTickHandler()
{}
void Timer1AHandler()
{}
void Timer2AHandler()
{}
