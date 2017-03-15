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
#include "driverlib/timer.h"

extern void config_GPIO();
extern void config_timer();
extern void gpiob_interrupt_handler();

bool data_to_tx[2048];
int tx_front = 0;
int tx_back = 0;
void send_data(int);

void timer0_interrrupt_handler()
{
    TimerIntClear(TIMER0_BASE, TIMER_TIMA_TIMEOUT);
    send_data(3);
}

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

void send_data(int n)
{
    uint8_t pin_n = 1<<n;
    while(tx_back < tx_front)
    {
        bool ab = data_to_tx[tx_back++];
        GPIOPinWrite(GPIO_PORTB_BASE, pin_n, ab << n);
        SysCtlDelay(100);

    }
//    if(tx_back == tx_front)
//    {
//        GPIOPinWrite(GPIO_PORTB_BASE, pin_n, ab << n);
//        SysCtlDelay(100);
        tx_back = 0;
        tx_front = 0;

//        g_bRxAvailable = 0;
//    }

}

void tx_byte(uint8_t byte)
{
    int j = 0;
    for(j = 0; j < 8; j++)
    {
        uint8_t a = byte;
        data_to_tx[tx_front++] = (byte >> j)&(0x01);
//        tx_front = tx_front + 1;
    }
}



int main()
{
    SysCtlClockSet(SYSCTL_SYSDIV_4 | SYSCTL_USE_PLL | SYSCTL_XTAL_16MHZ | SYSCTL_OSC_MAIN);
    config_timer();
    config_GPIO();
    GPIOPinTypeGPIOOutput(GPIO_PORTF_BASE,GPIO_PIN_2 | GPIO_PIN_3);
    int count = 0;
//    int data_count = 0;
    int t_i = 100;
//    while(t_i)
//    {
//        tx_byte(0b10101010);
//        send_data(3);
//        t_i--;
////        SysCtlDelay(10);
//    }
    IntMasterEnable();
    TimerEnable(TIMER0_BASE, TIMER_A);

    while(1)
    {
//        tx_byte(0b10101001);
        tx_byte(0b11001010);
//        tx_byte(0b11111111);
//        tx_byte(0b01010101);

//        SysCtlDelay(800);
//        send_data(3);


//        if(count% 2 == 1)
//        {
//            GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_2, GPIO_PIN_2);
//        }
//        else
//        {
//            GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_2, 0x00);
//        }
//
//        if(count %4 == 2)
//        {
//            GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_3, 0x00);
//        }
//        else if (count %4 ==0)
//        {
//            GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_3, GPIO_PIN_3);
//
//            count = 0;
//        }
//        count++;
//
//        SysCtlDelay(200);
//        val_to_write++;

    }

}
