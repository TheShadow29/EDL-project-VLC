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

int main()
{
    SysCtlClockSet(SYSCTL_SYSDIV_2_5 | SYSCTL_USE_PLL | SYSCTL_XTAL_16MHZ | SYSCTL_OSC_MAIN);
    config_GPIO();
    GPIOPinTypeGPIOOutput(GPIO_PORTF_BASE,GPIO_PIN_2 | GPIO_PIN_3);
    int val_to_write = 0;
    int data_count = 0;
    while(1)
    {
//        val_to_write ++;
        if(val_to_write% 2 == 1)
        {
            GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_2, 0x02);
        }
        else
        {
            GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_2, 0x00);
        }

        if(val_to_write %4 == 2)
        {
            GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_3, 0x08);
        }
        else if (val_to_write %4 ==0)
        {
            GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_3, 0x00);
            val_to_write = 0;
        }
        val_to_write++;

        SysCtlDelay(200);
//        val_to_write++;
    }

}
