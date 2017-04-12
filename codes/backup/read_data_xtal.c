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
//int rx_temp_data[6144];
//int rx_temp_data_ptr;
uint8_t final_buff[1500];
int final_buff_ptr;
int first_start;
int32_t see_bit[4];
int see_bit_counter;
int see_bit_counter2;
int32_t data_in_ptr;
int offset;
int save_start;
int sv_st_tmp;
int see_bit_start;

int rx_counter;
int urt_send_counter;
uint8_t st_byt[4];
//int rx_counter;

void init_zero()
{
    int k = 0;
//    for(k = 0; k < 6144; k++)
//    {
//        data_in[k] = 0;
//    }
//    for(k = 0; k < 6144;k++)
//    {
//        rx_temp_data[k] = 0;
//    }
    for(k = 0; k < 256; k++)
    {
        final_buff[k] = 0;
    }

    data_in_ptr = 0;
//    rx_temp_data_ptr = 0;
    save_start = 0;
    final_buff_ptr = 0;
    offset = 0;
//    int j1 =0;
//    for(j1 = 0; j1 < 8; j1++)
//    {
//        data_in[data_in_ptr++] = 1;
//        rx_temp_data[rx_temp_data_ptr++] = 0;
//    }
    see_bit_counter = 0;
    see_bit[0] = 0;
    see_bit[1] = 0;
    see_bit[2] = 0;
    see_bit[3] = 0;
    see_bit_start = 0;
    see_bit_counter2 = 0;
    st_byt[0] = 3;
    st_byt[1] = 4;
    st_byt[2] = 5;
    st_byt[3] = 4;
    rx_counter = 0;
    first_start = 0;
    sv_st_tmp = 0;
    urt_send_counter = 0;
}

void uart_rx()
{
    SysCtlPeripheralEnable(SYSCTL_PERIPH_UART0);
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOA);

    GPIOPinConfigure(GPIO_PA0_U0RX);
    GPIOPinConfigure(GPIO_PA1_U0TX);

    GPIOPinTypeUART(GPIO_PORTA_BASE, GPIO_PIN_0 | GPIO_PIN_1);

    UARTConfigSetExpClk(UART0_BASE, SysCtlClockGet() , 115200,
                            (UART_CONFIG_WLEN_8 | UART_CONFIG_STOP_ONE | UART_CONFIG_PAR_NONE));
    IntEnable(INT_UART0);
    UARTIntEnable(UART0_BASE, UART_INT_RX | UART_INT_TX);
    int j = 0;
    for(j = 0; j < final_buff_ptr-2;j++)
    {
        UARTCharPut(UART0_BASE, final_buff[j]);
    }

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
//    if(sv_st_tmp == 0)
//    {
//        see_bit[see_bit_counter++] = dat_1;
//        if(see_bit[see_bit_counter- 1] == st_byt[3] && see_bit[see_bit_counter -2] == st_byt[2] &&
//                see_bit[see_bit_counter-3] == st_byt[1] && see_bit[see_bit_counter-4] == st_byt[0])
//        {
//
//        }
//        else if (see_bit[see_bit_counter- 1] == st_byt[0] && see_bit[see_bit_counter -2] == st_byt[3] &&
//                see_bit[see_bit_counter-3] == st_byt[2] && see_bit[see_bit_counter-4] == st_byt[1])
//        {
//
//        }
//        else if (see_bit[see_bit_counter- 1] == st_byt[1] && see_bit[see_bit_counter -2] == st_byt[0] &&
//                see_bit[see_bit_counter-3] == st_byt[3] && see_bit[see_bit_counter-4] == st_byt[2])
//        {
//
//        }
//        else if (see_bit[see_bit_counter- 1] == st_byt[2] && see_bit[see_bit_counter -2] == st_byt[1] &&
//                see_bit[see_bit_counter-3] == st_byt[0] && see_bit[see_bit_counter-4] == st_byt[3])
//        {
//
//        }
//        else
//        {
//            see_bit[0] = 0;
//            see_bit[1] = 0;
//            see_bit[2] = 0;
//            see_bit[3] = 0;
//            see_bit_counter = 0;
//        }
//    }
//
    if(sv_st_tmp == 0)
    {
        if (dat_1 == st_byt[0] && see_bit_start == 0)
        {
            see_bit[0] = st_byt[0];
            see_bit_counter = 0;

        }
        if(see_bit_counter == 4 && dat_1 == st_byt[1] && see_bit[0] == st_byt[0])
        {
            see_bit[1] = st_byt[1];
            see_bit_counter++;
            see_bit_counter2 = 0;
                    save_start = 1;
            rx_counter = 0;
            //        first_start = rx_temp_data_ptr;
            sv_st_tmp = 1;
        }
        else
        {
            see_bit_counter++;
            see_bit_start = 0;
        }
    }
//    else
//    {
//        if(dat_1 == st_byt[2])
//    }
//    if(see_bit_counter2 == 4 && dat_1 == st_byt[2] && see_bit[1] = st_byt[1] && see_bit[0] = st_byt[0] && sv_st_tmp == 1)
//    {
//        see_bit[2] = st_byt[2];
//        see_bit_counter2++;
//    }
//    if(see_bit_counter2 == )
//    rx_temp_data[rx_temp_data_ptr++] = dat_1;

    if(save_start == 1)
    {
        if(rx_counter != 0 && rx_counter % 4 == 0 && rx_counter%8 == 0)
        {
            final_buff[final_buff_ptr] += (dat &0xf0);

            if(final_buff[final_buff_ptr] == 'D' && final_buff[final_buff_ptr - 1] == 'N' && final_buff[final_buff_ptr-2] == 'E')
            {
                GPIOIntDisable(GPIO_PORTB_BASE, GPIO_PIN_0);
                uart_rx();
            }
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
//    if(rx_temp_data_ptr == 6144)
//    {
//        rx_temp_data_ptr = 0;
//    }


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
