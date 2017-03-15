/*
 * tx_data_over_usb.c
 *
 *  Created on: 15-Mar-2017
 *      Author: arktheshadow
 */
#include <stdbool.h>
#include <stdint.h>
#include "inc/hw_ints.h"
#include "inc/hw_memmap.h"
#include "inc/hw_nvic.h"
#include "inc/hw_types.h"
#include "driverlib/debug.h"
#include "driverlib/fpu.h"
#include "driverlib/gpio.h"
#include "driverlib/interrupt.h"
#include "driverlib/pin_map.h"
#include "driverlib/sysctl.h"
#include "driverlib/timer.h"
#include "driverlib/uart.h"
#include "driverlib/rom.h"
#include "driverlib/pwm.h"
#include "usblib/usblib.h"
#include "usblib/usb-ids.h"
#include "usblib/device/usbdevice.h"
#include "usblib/device/usbdbulk.h"
#include "utils/uartstdio.h"
#include "utils/ustdlib.h"
#include "usb_bulk_structs.h"

bool data_to_tx[256];
int tx_front = 0;
int tx_back = 0;

volatile uint8_t g_ui8ParallelOut = 0b01101001;
volatile bool g_bIntDone = 0;
volatile bool g_bParallelDataReady = 0;
volatile uint32_t g_ui32SymbolsTx = 0;
//volatile bool g_bOutputMux = 0;

volatile bool g_bRxAvailable = 0;
volatile tUSBDBulkDevice * g_psRxDevice;
volatile uint8_t * g_pvRxData;
volatile uint32_t g_ui32NumBytes = 0;
uint32_t rx_array_pos = 0;
uint8_t start_count = 0;


//*****************************************************************************
//
// Variables tracking transmit and receive counts.
//
//*****************************************************************************
volatile uint32_t g_ui32TxCount = 0;
volatile uint32_t g_ui32RxCount = 0;
#ifdef DEBUG
uint32_t g_ui32UARTRxErrors = 0;
#endif


#define OUTPUT_PORT SYSCTL_PERIPH_GPIOB
#define OUTPUT_BASE GPIO_PORTB_BASE
//#define OUTPUT_PINS (GPIO_PIN_7 | GPIO_PIN_6 | GPIO_PIN_5 | GPIO_PIN_4 | GPIO_PIN_3 | GPIO_PIN_2 | GPIO_PIN_1 | GPIO_PIN_0)
#define OUTPUT_PINS (GPIO_PIN_3 | GPIO_PIN_2 | GPIO_PIN_1 | GPIO_PIN_0)


#define OUTPUT2_PORT SYSCTL_PERIPH_GPIOE
#define OUTPUT2_BASE GPIO_PORTE_BASE
#define OUTPUT2_PINS ( GPIO_PIN_3 | GPIO_PIN_2 | GPIO_PIN_1 | GPIO_PIN_0)

//*****************************************************************************
//
// Debug-related definitions and declarations.
//
// Debug output is available via UART0 if DEBUG is defined during build.
//
//*****************************************************************************
#ifdef DEBUG
//*****************************************************************************
//
// Map all debug print calls to UARTprintf in debug builds.
//
//*****************************************************************************
#define DEBUG_PRINT UARTprintf

#else

//*****************************************************************************
//
// Compile out all debug print calls in release builds.
//
//*****************************************************************************
#define DEBUG_PRINT while(0) ((int (*)(char *, ...))0)
#endif

//*****************************************************************************
//
// Flags used to pass commands from interrupt context to the main loop.
//
//*****************************************************************************
#define COMMAND_PACKET_RECEIVED 0x00000001
#define COMMAND_STATUS_UPDATE   0x00000002

volatile uint32_t g_ui32Flags = 0;

//*****************************************************************************
//
// Global flag indicating that a USB configuration has been set.
//
//*****************************************************************************
static volatile bool g_bUSBConfigured = false;

//*****************************************************************************
//
// The error routine that is called if the driver library encounters an error.
//
//*****************************************************************************
#ifdef DEBUG
void
__error__(char *pcFilename, uint32_t ui32Line)
{
    UARTprintf("Error at line %d of %s\n", ui32Line, pcFilename);
    while(1)
    {
    }
}
#endif


void
ExternalClockIntHandler(void)
{
    //if(g_bOutputMux)
    if(GPIOPinRead(GPIO_PORTF_BASE, GPIO_PIN_4)){
        GPIOPinWrite(OUTPUT_BASE,OUTPUT_PINS,g_ui8ParallelOut%16);
        //GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_2|GPIO_PIN_3, 0b10);
    }
    else
    {
        GPIOPinWrite(OUTPUT2_BASE,OUTPUT2_PINS,g_ui8ParallelOut/16);
        g_bIntDone = 1;
        g_bParallelDataReady = 0;
        g_ui32SymbolsTx ++;
        //GPIOPinWrite(GPIO_PORTF_BASE, GPIO_PIN_2|GPIO_PIN_3, 0b01);
    }
    //else
    //GPIOPinWrite(OUTPUT2_BASE,OUTPUT2_PINS,outData);

    //ROM_TimerIntClear(TIMER0_BASE, TIMER_TIMB_TIMEOUT);
}

//*****************************************************************************
//
// Handles bulk driver notifications related to the transmit channel (data to
// the USB host).
//
// \param pvCBData is the client-supplied callback pointer for this channel.
// \param ui32Event identifies the event we are being notified about.
// \param ui32MsgValue is an event-specific value.
// \param pvMsgData is an event-specific pointer.
//
// This function is called by the bulk driver to notify us of any events
// related to operation of the transmit data channel (the IN channel carrying
// data to the USB host).
//
// \return The return value is event-specific.
//
//*****************************************************************************
uint32_t
TxHandler(void *pvCBData, uint32_t ui32Event, uint32_t ui32MsgValue,
          void *pvMsgData)
{
    if(ui32Event == USB_EVENT_TX_COMPLETE)
    {
        g_ui32TxCount += ui32MsgValue;
    }

    DEBUG_PRINT("TX complete %d\n", ui32MsgValue);

    return(0);
}

//*****************************************************************************
//
// Handles bulk driver notifications related to the receive channel (data from
// the USB host).
//
// \param pvCBData is the client-supplied callback pointer for this channel.
// \param ui32Event identifies the event we are being notified about.
// \param ui32MsgValue is an event-specific value.
// \param pvMsgData is an event-specific pointer.
//
// This function is called by the bulk driver to notify us of any events
// related to operation of the receive data channel (the OUT channel carrying
// data from the USB host).
//
// \return The return value is event-specific.
//
//*****************************************************************************
uint32_t
RxHandler(void *pvCBData, uint32_t ui32Event,
          uint32_t ui32MsgValue, void *pvMsgData)
{
    switch(ui32Event)
    {
    case USB_EVENT_CONNECTED:
    {
        g_bUSBConfigured = true;
        UARTprintf("Host connected.\n");

        USBBufferFlush(&g_sTxBuffer);
        USBBufferFlush(&g_sRxBuffer);

        break;
    }

    case USB_EVENT_DISCONNECTED:
    {
        g_bUSBConfigured = false;
        UARTprintf("Host disconnected.\n");
        break;
    }

    case USB_EVENT_RX_AVAILABLE:
    {
        //tUSBDBulkDevice *psDevice;
        g_psRxDevice = (tUSBDBulkDevice *)pvCBData;

        g_bRxAvailable = 1;
        g_pvRxData = pvMsgData;
        g_ui32NumBytes += ui32MsgValue;

    }

    case USB_EVENT_SUSPEND:
    case USB_EVENT_RESUME:
    {
        break;
    }

    default:
    {
        break;
    }
    }

    return(0);
}

//*****************************************************************************
//
// Configure the UART and its pins.  This must be called before UARTprintf().
//
//*****************************************************************************
void
ConfigureUART(void)
{
    //
    // Enable the GPIO Peripheral used by the UART.
    //
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOA);

    //
    // Enable UART0
    //
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_UART0);

    //
    // Configure GPIO Pins for UART mode.
    //
    ROM_GPIOPinConfigure(GPIO_PA0_U0RX);
    ROM_GPIOPinConfigure(GPIO_PA1_U0TX);
    ROM_GPIOPinTypeUART(GPIO_PORTA_BASE, GPIO_PIN_0 | GPIO_PIN_1);

    //
    // Use the internal 16MHz oscillator as the UART clock source.
    //
    UARTClockSourceSet(UART0_BASE, UART_CLOCK_PIOSC);

    //
    // Initialize the UART for console I/O.
    //
    UARTStdioConfig(0, 115200, 16000000);
}


void tx_byte(uint8_t byte)
{
    int j = 0;
    for(j = 0; j < 8; j++)
    {
        uint8_t a = byte;
        data_to_tx[tx_front++] = (byte >> j)&(0x01);
    }
}

void timer0_config()
{
    int freq = 50000;
    SysCtlPeripheralEnable(SYSCTL_PERIPH_TIMER0);
    TimerConfigure(TIMER0_BASE, TIMER_CFG_PERIODIC);
    int ui32Period = (SysCtlClockGet() / freq) /4;
    TimerLoadSet(TIMER0_BASE, TIMER_A, ui32Period - 1);
    IntEnable(INT_TIMER0A);
    TimerIntEnable(TIMER0_BASE, TIMER_TIMA_TIMEOUT);
    IntMasterEnable();
    TimerEnable(TIMER0_BASE, TIMER_A);
}
void Timer0IntHandler()
{
    //    Clear the timer
    TimerIntClear(TIMER0_BASE, TIMER_TIMA_TIMEOUT);
    if (tx_back < tx_front)
        //    Read the current state and write back the opposite
    {
        bool ab = data_to_tx[tx_back++];
        GPIOPinWrite(GPIO_PORTB_BASE, GPIO_PIN_0, ab);
    }
    else
    {
        GPIOPinWrite(GPIO_PORTB_BASE, GPIO_PIN_0, 0x00);
    }
}

void send_data()
{
    while (tx_back < tx_front)
    {
        bool ab = data_to_tx[tx_back++];
        GPIOPinWrite(GPIO_PORTB_BASE, GPIO_PIN_0, ab);
        SysCtlDelay(1);
    }
    if(tx_back == tx_front)
    {
        tx_back = 0;
        tx_front = 0;
        g_bRxAvailable = 0;
    }
}


int main()
{

    // Set the clocking to run from the PLL at 50MHz
    ROM_SysCtlClockSet(SYSCTL_SYSDIV_4 | SYSCTL_USE_PLL | SYSCTL_OSC_MAIN |
                       SYSCTL_XTAL_16MHZ);

    //Enable Port B for output
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOB);
    ROM_GPIOPinTypeGPIOOutput(GPIO_PORTB_BASE, 0xff);


    // Open UART0 and show the application name on the UART.
    ConfigureUART();

    UARTprintf("\033[2JLifi Transmitter\n");
    UARTprintf("---------------------------------\n\n");

    // Not configured initially.
    g_bUSBConfigured = false;

    // Enable the GPIO peripheral used for USB, and configure the USB
    // pins.
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOD);
    ROM_GPIOPinTypeUSBAnalog(GPIO_PORTD_BASE, GPIO_PIN_4 | GPIO_PIN_5);


    // Tell the user what we are up to.
    UARTprintf("Configuring USB\n");

    // Initialize the transmit and receive buffers.
    USBBufferInit(&g_sTxBuffer);
    USBBufferInit(&g_sRxBuffer);

    // Set the USB stack mode to Device mode with VBUS monitoring.
    USBStackModeSet(0, eUSBModeForceDevice, 0);

    // Pass our device information to the USB library and place the device
    // on the bus.
    USBDBulkInit(0, &g_sBulkDevice);

    // Wait for initial configuration to complete.
    UARTprintf("Waiting for host...\n");


    rx_array_pos = 0;
    //    timer0_config();


    while(1)
    {
//        tx_byte(0b11001010);

//        send_data();


        if(g_bRxAvailable)
        {
//            if(start_count < 30)
//            {
//                start_count++;
//                g_ui32NumBytes -- ;
////                g_bRxAvailable = 0;
////                continue;
//            }
//            else
//            {
                while(g_ui32NumBytes)
                {
                    tx_byte(g_pui8USBRxBuffer[rx_array_pos]);
                    send_data();
                    g_ui32NumBytes -- ;
                    rx_array_pos = (rx_array_pos+1)%BULK_BUFFER_SIZE;
                }
//            }

        }
    }

}
