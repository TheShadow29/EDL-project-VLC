/*
 * receiver_main.c
 *
 *  Created on: 06-Mar-2017
 *      Author: arktheshadow
 */

//#include "read_data_xtal.c"
#include <stdint.h>
#include <stdbool.h>
#include "inc/hw_types.h"
#include "inc/hw_memmap.h"
#include "driverlib/gpio.h"
#include "driverlib/uart.h"
#include "driverlib/pin_map.h"
#include "driverlib/sysctl.h"
#include "inc/hw_ints.h"
#include "driverlib/interrupt.h"

extern void config_GPIO();
extern void gpiob_interrupt_handler();

void single_pin_write(char c, int n, int x)
{
//    n= n +1;
    if (c == 'b')
    {
        if (x == 1)
        {
            GPIOPinWrite(GPIO_PORTB_BASE,1<<n,1<<n);
        }
        else
        {
            GPIOPinWrite(GPIO_PORTB_BASE,1<<n,0);
        }
    }
    else if (c == 'f')
    {
        if (x==1)
        {
            GPIOPinWrite(GPIO_PORTF_BASE, 1<<n,1<< n);
        }
        else
        {
            GPIOPinWrite(GPIO_PORTF_BASE, 0,1<< n);
        }
    }
}

int main()
{
    SysCtlClockSet(SYSCTL_SYSDIV_2_5 | SYSCTL_USE_PLL | SYSCTL_XTAL_16MHZ | SYSCTL_OSC_MAIN);
    config_GPIO();
    GPIOPinTypeGPIOOutput(GPIO_PORTF_BASE,GPIO_PIN_2 | GPIO_PIN_3);
    int count = 0;
//    int data_count = 0;
    while(1)
    {
        if(count% 2 == 1)
        {
            GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_2, GPIO_PIN_2);
        }
        else
        {
            GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_2, 0x00);
        }

        if(count %4 == 2)
        {
            GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_3, 0x00);
        }
        else if (count %4 ==0)
        {
            GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_3, GPIO_PIN_3);

            count = 0;
        }
        count++;

        SysCtlDelay(200);
//        val_to_write++;
    }

}
