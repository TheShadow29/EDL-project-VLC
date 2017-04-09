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
#include "driverlib/timer.h"

//int32_t data_in[6144];
int rx_temp_data[6144];
int rx_temp_data_ptr;
int final_buff[256];
int final_buff_ptr;
int first_start;
int32_t see_bit[2];
int see_bit_counter;
int32_t data_in_ptr;
int offset;
int save_start;
int sv_st_tmp;
int see_bit_start;

int rx_counter;
//int rx_counter;

void init_zero()
{
    int k = 0;
//    for(k = 0; k < 6144; k++)
//    {
//        data_in[k] = 0;
//    }
    for(k = 0; k < 6144;k++)
    {
        rx_temp_data[k] = 0;
    }
    for(k = 0; k < 256; k++)
    {
        final_buff[k] = 0;
    }

    data_in_ptr = 0;
    rx_temp_data_ptr = 0;
    save_start = 0;
    final_buff_ptr = 0;
    offset = 0;
    int j1 =0;
    for(j1 = 0; j1 < 8; j1++)
    {
//        data_in[data_in_ptr++] = 1;
        rx_temp_data[rx_temp_data_ptr++] = 0;
    }
    see_bit_counter = 0;
    see_bit[0] = 0;
    see_bit[1] = 0;
    see_bit_start = 0;
    rx_counter = 0;
    first_start = 0;
    sv_st_tmp = 0;
}


void gpiob_interrupt_handler()
{
    GPIOIntClear(GPIO_PORTB_BASE, GPIO_PIN_0);
//    data_in[data_in_ptr] =
    uint8_t dat;
    uint8_t dat_1;
//    dat= GPIOPinRead(GPIO_PORTB_BASE, GPIO_PIN_1);
    dat = GPIOPinRead(GPIO_PORTC_BASE,0xff);
    dat_1 = (dat&0xf0) >> 4;
//
    if (dat_1 == 3 && see_bit_start == 0)
    {
        see_bit[0] = 3;
        see_bit_counter = 0;
    }

    if(see_bit_counter == 4 && dat_1 == 4 && see_bit[0] == 3 && sv_st_tmp == 0)
    {
        see_bit[1] = 4;
        see_bit_counter = 0;
        save_start = 1;
        rx_counter = 0;
        first_start = rx_temp_data_ptr;
        sv_st_tmp = 1;
    }
    else
    {
        see_bit_counter++;
        see_bit_start = 0;
    }
    rx_temp_data[rx_temp_data_ptr++] = dat_1;
//    if(rx_temp_data[rx_temp_data_ptr] == '')
//    data_in[data_in_ptr] = dat >> 1;
//    if(save_start == 0 && rx_temp_data[rx_temp_data_ptr-1] == 4 && rx_temp_data[rx_temp_data_ptr-5] == 3 )
//    {
//        save_start = 1;
//        first_start = rx_temp_data_ptr;
//        rx_counter = 0;
//    }
    if(save_start == 1)
    {
        if(rx_counter != 0 && rx_counter % 4 == 0 && rx_counter%8 == 0)
        {
            final_buff[final_buff_ptr] += (dat &0xf0);
            final_buff_ptr++;
        }
        else if(rx_counter%4  == 0 && rx_counter%8 == 4)
        {
            final_buff[final_buff_ptr] += (dat&0xf0) >> 4;

        }
        rx_counter++;

    }
//    int shift = data_in_ptr % 8;
//    if(data_in[data_in_ptr] == 1 && data_in[data_in_ptr- 1] == 1 && data_in[data_in_ptr-2] == 0 && data_in[data_in_ptr-3] == 0 &&
//            data_in[data_in_ptr-4] == 0 && data_in[data_in_ptr-5] == 0 && data_in[data_in_ptr-6] == 1 && data_in[data_in_ptr-7] == 0)
//    {
//        save_start = 1;
//        offset = data_in_ptr%8;
//    }


//    if(save_start == 1 && shift != 0)
//    {
//        rx_temp_data[rx_temp_data_ptr] +=  (dat >> 1) << shift;
//    }
//    else if (save_start == 1)
//    {
//        final_buff[final_buff_ptr++] = rx_temp_data[rx_temp_data_ptr++] ;
//    }
//    else
//    {
//        if(data_in[data_in_ptr] == 0 && data_in[data_in_ptr- 1] == 1 && data_in[data_in_ptr-2] == 0 && data_in[data_in_ptr-3] == 0 &&
//                data_in[data_in_ptr-4] == 0 && data_in[data_in_ptr-5] == 0 && data_in[data_in_ptr-6] == 1 && data_in[data_in_ptr-7] == 0)
//        {
//            save_start = 1;
//            offset = data_in_ptr%8;
//        }
//    }

//        if(rx_temp_data[rx_temp_data_ptr] == 'C')
//        {
//            save_start = 1;
//        }
////        rx_temp_data_ptr = 0;
//        rx_temp_data_ptr++;
//    }

//    data_in_ptr++;
//    if(data_in_ptr == 6144)
//    {
//        data_in_ptr = 6143;
//    }
//    if(rx_temp_data_ptr == 1024)
//    {
//        rx_temp_data_ptr = 0;
//        rx_counter = 0;
//    }
    if(rx_counter == 1024)
    {
        rx_counter = 0;
    }
    if(rx_temp_data_ptr == 6144)
    {
        rx_temp_data_ptr = 0;
    }


}

//void gpioc_interrupt_handler()
//{
//    GPIOIntClear(GPIO_PORTB_BASE, GPIO_PIN_4);
//    falling_edges_count++;
//
//    TimerEnable(TIMER0_BASE, TIMER_A);
//    //TimerValueGet
//}

void config_timer()
{
    uint32_t ui32Period;
    uint32_t freq = 200000;

    SysCtlPeripheralEnable(SYSCTL_PERIPH_TIMER0);
    TimerConfigure(TIMER0_BASE, TIMER_CFG_PERIODIC);
    ui32Period = (SysCtlClockGet() / freq) /4;
    TimerLoadSet(TIMER0_BASE, TIMER_A, ui32Period - 1);
//    TimerIntClear(TIMER0_BASE, TIMER_TIMA_TIMEOUT);
    TimerIntEnable(TIMER0_BASE, TIMER_TIMA_TIMEOUT);
    IntEnable(INT_TIMER0A);

//    SysCtlPeripheralEnable(SYSCTL_PERIPH_TIMER1);
//    TimerConfigure(TIMER1_BASE, TIMER_CFG_PERIODIC);
//    ui32Period = (SysCtlClockGet() / freq) /8;
//    TimerLoadSet(TIMER1_BASE, TIMER_A, ui32Period - 1);
////    TimerIntClear(TIMER0_BASE, TIMER_TIMA_TIMEOUT);
//    TimerIntEnable(TIMER1_BASE, TIMER_TIMA_TIMEOUT);
//    IntEnable(INT_TIMER1A);
//    IntMasterEnable();

}

void config_GPIO()
{
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOB);
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOC);
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOF);

    GPIOPinTypeGPIOOutput(GPIO_PORTF_BASE, GPIO_PIN_1);
    //PIN 0 : External Clock
    //Pin 1 : Data from the PLL
    GPIOPinTypeGPIOInput(GPIO_PORTB_BASE, GPIO_PIN_0|GPIO_PIN_1);
    GPIOPinTypeGPIOInput(GPIO_PORTC_BASE, GPIO_PIN_4|GPIO_PIN_5|GPIO_PIN_6|GPIO_PIN_7);
//    GPIOPinTypeGPIOOutput(GPIO_PORTB_BASE, GPIO_PIN_3|GPIO_PIN_4);
    GPIOIntDisable(GPIO_PORTB_BASE, GPIO_PIN_0);
    GPIOIntClear(GPIO_PORTB_BASE, GPIO_PIN_0);
    GPIOIntRegister(GPIO_PORTB_BASE,gpiob_interrupt_handler);
    GPIOIntTypeSet(GPIO_PORTB_BASE,GPIO_PIN_0,GPIO_RISING_EDGE);
//    GPIOIntTypeSet(GPIO_PORTB_BASE,GPIO_PIN_0,GPIO_FALLING_EDGE);

    GPIOIntEnable(GPIO_PORTB_BASE,GPIO_PIN_0);

//    GPIOIntDisable(GPIO_PORTC_BASE, GPIO_PIN_4);
//    GPIOIntClear(GPIO_PORTC_BASE, GPIO_PIN_4);
//    GPIOIntRegister(GPIO_PORTC_BASE,gpioc_interrupt_handler);
//    GPIOIntTypeSet(GPIO_PORTC_BASE,GPIO_PIN_4,GPIO_FALLING_EDGE);
//    GPIOIntEnable(GPIO_PORTC_BASE,GPIO_PIN_4);
//    IntMasterEnable();

}
