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

uint8_t character_get[100];
void send_bin(uint8_t bin);
void convert_char_to_bin(uint8_t ch);
void send_char();
void PortFIntHandler();
uint8_t bool_to_uint8();
int data_in_ptr;
bool character[8];
uint8_t char_to_send;

int rx_tester()
{
    SysCtlClockSet(SYSCTL_SYSDIV_4  | SYSCTL_USE_PLL | SYSCTL_OSC_MAIN | SYSCTL_XTAL_16MHZ);
    SysCtlPeripheralEnable(SYSCTL_PERIPH_UART0);
    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOA);

    GPIOPinConfigure(GPIO_PA0_U0RX);
    GPIOPinConfigure(GPIO_PA1_U0TX);

    GPIOPinTypeUART(GPIO_PORTA_BASE, GPIO_PIN_0 | GPIO_PIN_1);

    SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOF);
    GPIOPinTypeGPIOOutput(GPIO_PORTF_BASE, GPIO_PIN_0 | GPIO_PIN_2);

//    Interrupt configurations for PortF0
//    https://sites.google.com/site/luiselectronicprojects/tutorials/tiva-tutorials/tiva-gpio/digital-input-with-interrupt
    GPIOIntTypeSet(GPIO_PORTF_BASE,GPIO_PIN_0,GPIO_BOTH_EDGES);
    GPIOIntRegister(GPIO_PORTF_BASE,PortFIntHandler);

    GPIOIntEnable(GPIO_PORTF_BASE, GPIO_INT_PIN_4);


    UARTConfigSetExpClk(UART0_BASE, SysCtlClockGet() , 115200,
                        (UART_CONFIG_WLEN_8 | UART_CONFIG_STOP_ONE | UART_CONFIG_PAR_NONE));
    IntMasterEnable();
    IntEnable(INT_UART0);
    UARTIntEnable(UART0_BASE, UART_INT_RX | UART_INT_TX);



    UARTCharPut(UART0_BASE, 'E');
    UARTCharPut(UART0_BASE, 'n');
    UARTCharPut(UART0_BASE, 't');
    UARTCharPut(UART0_BASE, 'e');
    UARTCharPut(UART0_BASE, 'r');
    UARTCharPut(UART0_BASE, ' ');
    UARTCharPut(UART0_BASE, 'T');
    UARTCharPut(UART0_BASE, 'e');
    UARTCharPut(UART0_BASE, 'x');
    UARTCharPut(UART0_BASE, 't');
    UARTCharPut(UART0_BASE, ':');
    UARTCharPut(UART0_BASE, ' ');
    data_in_ptr = 0;
    while(1)
    {
        //        if (UARTCharsAvail(UART0_BASE))
        //        {
        //            UARTCharPut(UART0_BASE, UARTCharGet(UART0_BASE));
        //        }
    }
}

void send_char()
{
    UARTCharPut(UART0_BASE, char_to_send);
}

void PortFIntHandler()
{
//    Avoid Infinite Loop
//    GPIOIntClear(GPIO_PORTF_BASE, GPIO_INT_PIN_0);
    uint32_t status=0;
    status = GPIOIntStatus(GPIO_PORTF_BASE,true);
    GPIOIntClear(GPIO_PORTF_BASE,status);
    int32_t value = GPIOPinRead(GPIO_PORTF_BASE,GPIO_PIN_4);

    character[data_in_ptr] = value;
    data_in_ptr = data_in_ptr + 1;
    if (data_in_ptr == 8)
    {
        data_in_ptr = 0;
        char_to_send = bool_to_uint8(character);
        send_char();
    }
}

uint8_t bool_to_uint8()
{
    int i =0;
    uint8_t ch = 0;
    for (i = 0; i < 8; i++)
    {
        ch = ch + (1 << i) * character[i];
    }
    return ch;
}

void UARTIntHandler()
{
    uint32_t ui32Status;
    ui32Status = UARTIntStatus(UART0_BASE, true);
    UARTIntClear(UART0_BASE, ui32Status);
    int i = 0;
    while(UARTCharsAvail(UART0_BASE)) //loop while there are chars
    {
        int32_t ucData = UARTCharGet(UART0_BASE);
        character_get[i++] = ucData;
        if (ucData == 0x41)
        {
                            UARTCharPut(UART0_BASE, ucData);

            convert_char_to_bin(0x42);

            break;
        }
        //        UARTCharPutNonBlocking(UART0_BASE, 0x41);
        //echo character
        GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_2, GPIO_PIN_2); //blink LED
        SysCtlDelay(SysCtlClockGet() / (1000 * 3)); //delay ~1 msec
        GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_2, 0); //turn off LED
    }
    //    convert_to_ascii(i);

}

void convert_char_to_bin(uint8_t ch)
{
    int j = 0;
    for(j = 0; j < 8; j++)
    {
        uint8_t b = ch%2;
        send_bin(b);
        ch = ch/2;
    }

}


void send_bin(uint8_t bin)
{
    GPIOPinWrite(GPIO_PORTF_BASE,GPIO_PIN_0,bin);
}


















