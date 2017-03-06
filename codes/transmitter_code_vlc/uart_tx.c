/*
 * uart_tx.c
 *
 *  Created on: 13-Feb-2017
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

void delay(int n)
{
    volatile uint32_t ui32Loop;

    for(ui32Loop = 0; ui32Loop < n; ui32Loop++)
    {
    }
}
int max_gpio_toggle()
{
    SysCtlClockSet(SYSCTL_SYSDIV_4  | SYSCTL_USE_PLL | SYSCTL_OSC_MAIN | SYSCTL_XTAL_16MHZ);

    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOF);
    GPIOPinTypeGPIOOutput(GPIO_PORTF_BASE, GPIO_PIN_3);

    while(1)
    {
        GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_3, GPIO_PIN_3);
//        delay(1);
        GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_3, 0x0);
//        delay(1);
    }
}
