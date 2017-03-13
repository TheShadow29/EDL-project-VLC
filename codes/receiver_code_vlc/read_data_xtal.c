/*
 * read_data_xtal.c
 *
 *  Created on: 06-Mar-2017
 *      Author: arktheshadow
 */
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

int32_t data_in[100];
int32_t see_bit[2];
int32_t counter;

void demod()
{
    if (see_bit[0] == 0 && see_bit[1] == 1)
    {
        data_in[counter/2] = 0;
    }
    else if (see_bit[0] == 1 && see_bit[1] == 0)
    {
       data_in[counter/2] = 1;
    }
    else
    {
        data_in[counter/2] = 2;
    }
}

void gpiob_interrupt_handler()
{
    GPIOIntClear(GPIO_PORTB_BASE, GPIO_PIN_0);
//    data_in[counter] =

    if (counter % 2 == 1)
    {
        see_bit[1] = GPIOPinRead(GPIO_PORTB_BASE,GPIO_PIN_1);
        see_bit[1] = see_bit[1] >>1;
        GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_1, 0x01 );
        demod();
    }
    else
    {
        see_bit[0] = GPIOPinRead(GPIO_PORTB_BASE,GPIO_PIN_1);
        see_bit[0] = see_bit[0] >>1;
        GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_1,0x00);
    }
    counter = counter + 1;

}

void config_GPIO()
{
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOB);
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOF);
    GPIOPinTypeGPIOOutput(GPIO_PORTF_BASE, GPIO_PIN_1);
    //PIN 0 : External Clock
    //Pin 1 : Data from the PLL
    GPIOPinTypeGPIOInput(GPIO_PORTB_BASE, GPIO_PIN_0|GPIO_PIN_1);
    GPIOIntDisable(GPIO_PORTB_BASE, GPIO_PIN_0);
    GPIOIntClear(GPIO_PORTB_BASE, GPIO_PIN_0);
    GPIOIntRegister(GPIO_PORTB_BASE,gpiob_interrupt_handler);
    GPIOIntTypeSet(GPIO_PORTB_BASE,GPIO_PIN_0,GPIO_RISING_EDGE);
    GPIOIntEnable(GPIO_PORTB_BASE,GPIO_PIN_0);
    IntMasterEnable();
    counter = 0;

}


