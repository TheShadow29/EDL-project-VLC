/*
 * tx_direct_buffer.c
 *
 *  Created on: 23-Mar-2017
 *      Author: arktheshadow
 */
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

//extern void config_GPIO();
//extern void config_timer();
//extern void gpiob_interrupt_handler();

//100 -> 38.25k
//75 -> 49.65k
//50 -> 70.71k
//float freq = 50;

int data_buff_size = 2048;
bool data_to_tx[6144];
bool synch_buffer[4096];
int sync_tx_front = 0;
int sync_tx_back = 0;
int tx_front = 0;
int tx_back = 0;
int cl_delay = 3233.6/(85 - 6.1629);
int n_bits_tx = 6;
//int test_cl = 100;
bool clk = 0;
void send_data(int);
void tx_byte(uint8_t);
uint8_t byte_test = 0b11001010;
void config_GPIO()
{
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOB);
//    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOC);
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOF);
    GPIOPinTypeGPIOOutput(GPIO_PORTF_BASE, GPIO_PIN_1);
    //PIN 0 : External Clock
    //Pin 1 : Data from the PLL
    GPIOPinTypeGPIOInput(GPIO_PORTB_BASE, GPIO_PIN_0|GPIO_PIN_1);
//    GPIOPinTypeGPIOInput(GPIO_PORTC_BASE, GPIO_PIN_4);
    GPIOPinTypeGPIOOutput(GPIO_PORTB_BASE, GPIO_PIN_3|GPIO_PIN_4);
    GPIOIntDisable(GPIO_PORTB_BASE, GPIO_PIN_0);
    GPIOIntClear(GPIO_PORTB_BASE, GPIO_PIN_0);
//    GPIOIntRegister(GPIO_PORTB_BASE,gpiob_interrupt_handler);
    GPIOIntTypeSet(GPIO_PORTB_BASE,GPIO_PIN_0,GPIO_FALLING_EDGE);
    GPIOIntEnable(GPIO_PORTB_BASE,GPIO_PIN_0);

//    GPIOIntDisable(GPIO_PORTC_BASE, GPIO_PIN_4);
//    GPIOIntClear(GPIO_PORTC_BASE, GPIO_PIN_4);
//    GPIOIntRegister(GPIO_PORTC_BASE,gpioc_interrupt_handler);
//    GPIOIntTypeSet(GPIO_PORTC_BASE,GPIO_PIN_4,GPIO_FALLING_EDGE);
//    GPIOIntEnable(GPIO_PORTC_BASE,GPIO_PIN_4);
//    IntMasterEnable();
//    counter = 0;

}

void timer0_interrrupt_handler()
{
//    send_data(3);
    TimerIntClear(TIMER0_BASE, TIMER_TIMA_TIMEOUT);

//    tx_byte(0b11001010);
//    send_data(3);
//    GPIOPinWrite(GPIO_PORTB_BASE, GPIO_PIN_3, data_to_tx[tx_back++] << 3);
//    SysCtlDelay(cl_delay);
}

void timer1_interrupt_handler()
{
    TimerIntClear(TIMER1_BASE, TIMER_TIMA_TIMEOUT);
    GPIOPinWrite(GPIO_PORTB_BASE, GPIO_PIN_4, clk << 4);
    clk = !clk;
}


void send_data(int n)
{
    uint8_t pin_n = 1<<n;
    while(tx_back < tx_front)
    {
        bool ab = data_to_tx[tx_back++];
        GPIOPinWrite(GPIO_PORTB_BASE, pin_n, ab << n);
//        tx_back = (tx_back)%data_buff_size;
        SysCtlDelay(cl_delay);
//        tx_back = tx_back%tx_front;
        if(tx_back == tx_front)
        {
            tx_back = 3998;
        }
        else
        {
            tx_back = tx_back;
        }
     }

//    if(tx_back == tx_front)
//    {
//        GPIOPinWrite(GPIO_PORTB_BASE, pin_n, ab << n);
//        SysCtlDelay(100);

//        tx_back = 0;???????/

    //        tx_front = 0;

//        g_bRxAvailable = 0;
//    }

}

void tx_byte(uint8_t byte)
{
    int j = 0;
    for(j = 0; j < 8; j++)
    {
//        uint8_t a = byte;
        data_to_tx[tx_front++] = (byte >> j)&(0x01);
        data_to_tx[tx_front++] = !((byte >> j)&(0x01));
    }
}

void tx_byte_no_encoding(uint8_t byte)
{
    int j = 0;
    for(j = 0; j < 8; j++)
    {
//        uint8_t a = byte;
        data_to_tx[tx_front++] = (byte >> j)&(0x01);
    }
}

void send_sync_data(int n)
{
    uint8_t pin_n = 1<<n;
    while(sync_tx_back < sync_tx_front)
    {
        bool ab = synch_buffer[sync_tx_back++];
        GPIOPinWrite(GPIO_PORTB_BASE, pin_n, ab << n);
//        tx_back = (tx_back)%data_buff_size;
        SysCtlDelay(cl_delay);
//        tx_back = tx_back%tx_front;
        if(sync_tx_back == sync_tx_front)
        {
            sync_tx_back = 0;
        }
     }
}

void tx_to_synch_buffer(uint8_t byte)
{
    int j = 0;
    for(j = 0; j < 8; j++)
    {
//        uint8_t a = byte;
        synch_buffer[sync_tx_front++] = (byte >> j)&(0x01);
        synch_buffer[sync_tx_front++] = !((byte >> j)&(0x01));
    }
}

void tx_bits(bool bit)
{
         GPIOPinWrite(GPIO_PORTB_BASE, GPIO_PIN_3, bit << 3);
        SysCtlDelay(190);
}



int not_main()
 {
    SysCtlClockSet(SYSCTL_SYSDIV_4 | SYSCTL_USE_PLL | SYSCTL_XTAL_16MHZ | SYSCTL_OSC_MAIN);
//    config_timer();
    config_GPIO();
    GPIOPinTypeGPIOOutput(GPIO_PORTF_BASE,GPIO_PIN_2 | GPIO_PIN_3);
//    int count = 0;
//    int data_count = 0;
//    int t_i = 100000;
    int t_j = 1;

//    TimerEnable(TIMER0_BASE, TIMER_A);
//    TimerEnable(TIMER1_BASE,TIMER_A);
//    uint8_t bro_ka_byte = 0b10101010;
//    bool dat_bit = 0;
    t_j = 0;
    while(t_j < 500)
    {
        data_to_tx[tx_front++] = (t_j++)%2;
    }
    t_j = 0;

    while(t_j < n_bits_tx)
    {
        data_to_tx[tx_front++] = 1;
        data_to_tx[tx_front++] = 0;
        data_to_tx[tx_front++] = 1;
        data_to_tx[tx_front++] = 0;
        data_to_tx[tx_front++] = 0;
        data_to_tx[tx_front++] = 1;
        data_to_tx[tx_front++] = 1;
        data_to_tx[tx_front++] = 0;
        data_to_tx[tx_front++] = 0;
        data_to_tx[tx_front++] = 1;
        data_to_tx[tx_front++] = 1;
        data_to_tx[tx_front++] = 0;
        data_to_tx[tx_front++] = 1;
        data_to_tx[tx_front++] = 0;
        data_to_tx[tx_front++] = 0;
        data_to_tx[tx_front++] = 1;
        data_to_tx[tx_front++] = 0;
        data_to_tx[tx_front++] = 1;
        data_to_tx[tx_front++] = 1;
        data_to_tx[tx_front++] = 0;
        t_j++;
    }

//    while(t_j)
//    {
//        while(t_i)
//
//        {
//            int j;
//            for(j = 0; j < 8;j++)
//            {
//        //            dat_bit = (byte >> j) & 0x01;
//                GPIOPinWrite(GPIO_PORTB_BASE, GPIO_PIN_3, ((bro_ka_byte >> j) & 0x01) << 3);
//                SysCtlDelay(test_cl);
//            }
//            t_i--;
////            SysCtlDelay(cl_delay);
//        }
//        t_j--;
//    }



//    IntMasterEnable();

    while(1)
    {
//        int j;
//        for(j = 0; j < 8;j++)
//        {
//    //            dat_bit = (byte >> j) & 0x01;
//            GPIOPinWrite(GPIO_PORTB_BASE, GPIO_PIN_3, ((byte_test >> j) & 0x01) << 3);
//            SysCtlDelay(test_cl);
//        }

//        tx_bits(0);
//        tx_bits(1);

//        tx_byte(0b10101010);
        send_data(3);
//        tx_bits(0b11001010);

//        bool dat_bit;
//        byte = 0b11001010;
//        int j;
//        for(j = 0; j < 8;j++)
//        {
////            dat_bit = (byte >> j) & 0x01;
//            GPIOPinWrite(GPIO_PORTB_BASE, GPIO_PIN_3, ((byte >> j) & 0x01) << 3);
//            SysCtlDelay(190);
//        }


//        tx_byte(0b10101010);
//        GPIOPinWrite(GPIO_PORTB_BASE, GPIO_PIN_3, dat_bit << 3);
//        dat_bit = !dat_bit;
//        SysCtlDelay(190);
//        tx_byte(0b10101001);
//        tx_byte(0b11001010);
//        tx2_byte(0b1110001011001010);
//        tx_byte(0b11111111);
//        send_data(3);
//        tx_byte(0b01010101);
//        SysCtlDelay(20000);
//        send_data(3);
    }
}
