/*
 * read_data_xtal.c
 *
 *  Created on: 06-Mar-2017
 *      Author: arktheshadow
 */
//#include <stdint.h>
//#include <stdbool.h>
//#include "inc/hw_types.h"
//#include "inc/hw_memmap.h"
//#include "driverlib/gpio.h"
//#include "driverlib/uart.h"
//#include "driverlib/pin_map.h"
//#include "driverlib/sysctl.h"
//#include "inc/hw_ints.h"
//#include "driverlib/interrupt.h"
//#include "driverlib/timer.h"
#include <stdbool.h>
#include <stdint.h>
#include "inc/hw_ints.h"
#include "inc/hw_memmap.h"
#include "inc/hw_types.h"
#include "driverlib/debug.h"
#include "driverlib/fpu.h"
#include "driverlib/gpio.h"
#include "driverlib/interrupt.h"
#include "driverlib/pin_map.h"
#include "driverlib/sysctl.h"
#include "driverlib/systick.h"
#include "driverlib/timer.h"
#include "driverlib/uart.h"
#include "driverlib/rom.h"
#include "usblib/usblib.h"
#include "usblib/usb-ids.h"
#include "usblib/device/usbdevice.h"
#include "usblib/device/usbdbulk.h"
#include "utils/uartstdio.h"
#include "utils/ustdlib.h"
#include "usb_bulk_structs.h"

//extern uint32_t


int32_t data_in[2048];
int32_t see_bit[2];
int32_t counter;
int32_t rx_back = 0;

int falling_edges_count = 0;

void send_to_pc()
{
    counter = 0;
    data_in[counter++] = 0;
    data_in[counter++] = 0;
    data_in[counter++] = 0;
    data_in[counter++] = 0;
    data_in[counter++] = 1;
    data_in[counter++] = 1;
    data_in[counter++] = 0;
    data_in[counter++] = 0;

    uint32_t ui32Loop, ui32Space, ui32Count;
//    uint32_t ui32ReadIndex;
    uint32_t ui32WriteIndex;
    tUSBRingBufObject sTxRing;
    uint32_t ui32NumBytes = counter - rx_back;
    ui32NumBytes = 10;
    USBBufferInfoGet(&g_sTxBuffer, &sTxRing);
    ui32Space = USBBufferSpaceAvailable(&g_sTxBuffer);
    ui32Loop = (ui32Space < ui32NumBytes) ? ui32Space : ui32NumBytes;
    ui32Count = ui32Loop;
//    g_ui32RxCount += ui32NumBytes;

//    ui32ReadIndex = (uint32_t)(pui8Data - g_pui8USBRxBuffer);
    ui32WriteIndex = sTxRing.ui32WriteIndex;

//    while(1)
////    {
    int i = 0;
    int a = 0;
//    int b = 1;
    for(i = 0; i < 8;i++)
    {
        a = a +(1<<i)* data_in[rx_back++];
    }
    g_pui8USBTxBuffer[ui32WriteIndex] = a;
    USBBufferDataWritten(&g_sTxBuffer,1);
//        while(ui32Loop)
//            {
//                int x1 = 0;
//                for(i)
//                g_pui8USBTxBuffer[ui32WriteIndex] = data_in[rx_back++];
//                ui32Loop--;
//            }
//            USBBufferDataWritten(&g_sTxBuffer, ui32Count);
//            if(rx_back == counter)
//            {
////                break;
//                return;
//            }
//            else
//            {
//                ui32NumBytes = counter - rx_back;
//                ui32Space = USBBufferSpaceAvailable(&g_sTxBuffer);
//                ui32Loop = (ui32Space < ui32NumBytes) ? ui32Space : ui32NumBytes;
//            }
//    }


}

void init_zero()
{
    int k = 0;
    for(k = 0; k < 2048; k++)
    {
        data_in[k] = 0;
    }
}

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
    data_in[counter] = GPIOPinRead(GPIO_PORTB_BASE, GPIO_PIN_1);
//    data_in[counter] = data_in[counter] >> 1;

    if(counter > 2000)
    {
        send_to_pc();
    }

    if (counter % 2 == 1)
    {
        see_bit[1] = GPIOPinRead(GPIO_PORTB_BASE,GPIO_PIN_1);
        see_bit[1] = see_bit[1] >>1;
        GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_1, 0x01 );
//        demod();
    }
    else
    {
        see_bit[0] = GPIOPinRead(GPIO_PORTB_BASE,GPIO_PIN_1);
        see_bit[0] = see_bit[0] >>1;
        GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_1,0x00);
    }
    counter = counter + 1;
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
    GPIOIntRegister(GPIO_PORTB_BASE,gpiob_interrupt_handler);
//    GPIOIntTypeSet(GPIO_PORTB_BASE,GPIO_PIN_0,GPIO_RISING_EDGE);
    GPIOIntTypeSet(GPIO_PORTB_BASE,GPIO_PIN_0,GPIO_FALLING_EDGE);

    GPIOIntEnable(GPIO_PORTB_BASE,GPIO_PIN_0);

//    GPIOIntDisable(GPIO_PORTC_BASE, GPIO_PIN_4);
//    GPIOIntClear(GPIO_PORTC_BASE, GPIO_PIN_4);
//    GPIOIntRegister(GPIO_PORTC_BASE,gpioc_interrupt_handler);
//    GPIOIntTypeSet(GPIO_PORTC_BASE,GPIO_PIN_4,GPIO_FALLING_EDGE);
//    GPIOIntEnable(GPIO_PORTC_BASE,GPIO_PIN_4);
//    IntMasterEnable();
    counter = 0;

}

