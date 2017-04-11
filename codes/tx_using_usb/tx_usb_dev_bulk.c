//*****************************************************************************
//
// usb_dev_bulk.c - Main routines for the generic bulk device example.
//
// Copyright (c) 2012-2016 Texas Instruments Incorporated.  All rights reserved.
// Software License Agreement
// 
// Texas Instruments (TI) is supplying this software for use solely and
// exclusively on TI's microcontroller products. The software is owned by
// TI and/or its suppliers, and is protected under applicable copyright
// laws. You may not combine this software with "viral" open-source
// software in order to form a larger program.
// 
// THIS SOFTWARE IS PROVIDED "AS IS" AND WITH ALL FAULTS.
// NO WARRANTIES, WHETHER EXPRESS, IMPLIED OR STATUTORY, INCLUDING, BUT
// NOT LIMITED TO, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE APPLY TO THIS SOFTWARE. TI SHALL NOT, UNDER ANY
// CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL, OR CONSEQUENTIAL
// DAMAGES, FOR ANY REASON WHATSOEVER.
// 
// This is part of revision 2.1.3.156 of the EK-TM4C123GXL Firmware Package.
//
//*****************************************************************************

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

extern void tx_byte(uint8_t);
extern void tx_to_synch_buffer(uint8_t);
extern void send_sync_data(int);
extern void send_data(int);
extern void config_GPIO();
extern void config_timer();
bool start_timer_bit = 0;
extern bool *data_to_tx;
extern void send_sentence(char*,int);
extern void send_file();


uint8_t to_tx_buffer_temp[256];
int ptr_to_tx_buffer = 0;
extern int tx_front;

uint32_t ui32Loop, ui32Space, ui32Count;
uint32_t ui32ReadIndex;
uint32_t ui32WriteIndex;


//*****************************************************************************
//
//! \addtogroup example_list
//! <h1>USB Generic Bulk Device (usb_dev_bulk)</h1>
//!
//! This example provides a generic USB device offering simple bulk data
//! transfer to and from the host.  The device uses a vendor-specific class ID
//! and supports a single bulk IN endpoint and a single bulk OUT endpoint.
//! Data received from the host is assumed to be ASCII text and it is
//! echoed back with the case of all alphabetic characters swapped.
//!
//! A Windows INF file for the device is provided on the installation CD and
//! in the C:/ti/TivaWare-for-C-Series/windows_drivers directory of TivaWare C
//! series releases.  This INF contains information required to install the
//! WinUSB subsystem on Windowi16XP and Vista PCs.  WinUSB is a Windows
//! subsystem allowing user mode applications to access the USB device without
//! the need for a vendor-specific kernel mode driver.
//!
//! A sample Windows command-line application, usb_bulk_example, illustrating
//! how to connect to and communicate with the bulk device is also provided.
//! The application binary is installed as part of the ''Windows-side examples
//! for USB kits'' package (SW-USB-win) on the installation CD or via download
//! from http://www.ti.com/tivaware .  Project files are included to allow
//! the examples to be built using Microsoft VisualStudio 2008.  Source code
//! for this application can be found in directory
//! TivaWare-for-C-Series/tools/usb_bulk_example.
//
//*****************************************************************************

//*****************************************************************************
//
// The system tick rate expressed both as ticks per second and a millisecond
// period.
//
//*****************************************************************************
#define SYSTICKS_PER_SECOND     100
#define SYSTICK_PERIOD_MS       (1000 / SYSTICKS_PER_SECOND)

//*****************************************************************************
//
// The global system tick counter.
//
//*****************************************************************************
volatile uint32_t g_ui32SysTickCount = 0;

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

//*****************************************************************************
//
// Interrupt handler for the system tick counter.
//
//*****************************************************************************
void
SysTickIntHandler(void)
{
    //
    // Update our system tick counter.
    //
    g_ui32SysTickCount++;
}

//*****************************************************************************
//
// Receive new data and echo it back to the host.
//
// \param psDevice points to the instance data for the device whose data is to
// be processed.
// \param pui8Data points to the newly received data in the USB receive buffer.
// \param ui32NumBytes is the number of bytes of data available to be processed.
//
// This function is called whenever we receive a notification that data is
// available from the host. We read the data, byte-by-byte and swap the case
// of any alphabetical characters found then write it back out to be
// transmitted back to the host.
//
// \return Returns the number of bytes of data processed.
//
//*****************************************************************************

//ARKA new function
static uint32_t
NayaData(tUSBDBulkDevice *psDevice, uint8_t *pui8Data,
                  uint32_t ui32NumBytes)
{

    tUSBRingBufObject sTxRing;

    //
    // Get the current buffer information to allow us to write directly to
    // the transmit buffer (we already have enough information from the
    // parameters to access the receive buffer directly).
    //
    USBBufferInfoGet(&g_sTxBuffer, &sTxRing);

    //
    // How much space is there in the transmit buffer?
    //
    ui32Space = USBBufferSpaceAvailable(&g_sTxBuffer);

    //
    // How many characters can we process this time round?
    //
    ui32Loop = (ui32Space < ui32NumBytes) ? ui32Space : ui32NumBytes;
    ui32Count = ui32Loop;

    //
    // Update our receive counter.
    //
    g_ui32RxCount += ui32NumBytes;

    //
    // Dump a debug message.
    //
    DEBUG_PRINT("Received %d bytes\n", ui32NumBytes);

    //
    // Set up to process the characters by directly accessing the USB buffers.
    //
    ui32ReadIndex = (uint32_t)(pui8Data - g_pui8USBRxBuffer);
    ui32WriteIndex = sTxRing.ui32WriteIndex;

    while(ui32Loop)
    {

        // Copy the received character to the transmit buffer.
        //
        g_pui8USBTxBuffer[ui32WriteIndex] =
                g_pui8USBRxBuffer[ui32ReadIndex];
//        GPIOPinWrite(GPIO_PORTB_BASE, 0xff, g_pui8USBRxBuffer[ui32ReadIndex]);
        if (ui32ReadIndex >29)
        {
            tx_byte(g_pui8USBRxBuffer[ui32ReadIndex]);
            start_timer_bit = 1;
            to_tx_buffer_temp[ptr_to_tx_buffer++] = g_pui8USBRxBuffer[ui32ReadIndex];
//            if (ui32ReadIndex > 31)
//            {
//                if (to_tx_buffer_temp[ptr_to_tx_buffer] == 'B' && to_tx_buffer_temp[ptr_to_tx_buffer-1] == 'A')
//                {
//                    tx_front = tx_front - 16;
//                    start_timer_bit = 1;
////                    IntMasterEnable();
////                    TimerEnable(TIMER0_BASE, TIMER_A); // Start Timer 0A
//                }
//            }
        }




        //
        // Move to the next character taking care to adjust the pointer for
        // the buffer wrap if necessary.
        //
        ui32WriteIndex++;
        ui32WriteIndex = (ui32WriteIndex == BULK_BUFFER_SIZE) ?
                         0 : ui32WriteIndex;

        ui32ReadIndex++;
        ui32ReadIndex = (ui32ReadIndex == BULK_BUFFER_SIZE) ?
                        0 : ui32ReadIndex;

        ui32Loop--;
    }

    //
    // We've processed the data in place so now send the processed data
    // back to the host.
    //
    USBBufferDataWritten(&g_sTxBuffer, ui32Count);

    //UARTprintf("Wrote %d bytes\n", ui32Count);

    //
    // We processed as much data as we can directly from the receive buffer so
    // we need to return the number of bytes to allow the lower layer to
    // update its read pointer appropriately.
    //
    return(ui32Count);
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
    //
    // We are not required to do anything in response to any transmit event
    // in this example. All we do is update our transmit counter.
    //
    if(ui32Event == USB_EVENT_TX_COMPLETE)
    {
        g_ui32TxCount += ui32MsgValue;
    }

    //
    // Dump a debug message.
    //
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
    //
    // Which event are we being sent?
    //
    switch(ui32Event)
    {
        //
        // We are connected to a host and communication is now possible.
        //
        case USB_EVENT_CONNECTED:
        {
            g_bUSBConfigured = true;
//            UARTprintf("Host connected.\n");

            //
            // Flush our buffers.
            //
            USBBufferFlush(&g_sTxBuffer);
            USBBufferFlush(&g_sRxBuffer);

            break;
        }

        //
        // The host has disconnected.
        //
        case USB_EVENT_DISCONNECTED:
        {
            g_bUSBConfigured = false;
            UARTprintf("Host disconnected.\n");
            break;
        }

        //
        // A new packet has been received.
        //
        case USB_EVENT_RX_AVAILABLE:
        {
            tUSBDBulkDevice *psDevice;

            psDevice = (tUSBDBulkDevice *)pvCBData;
            //return(EchoNewDataToHost(psDevice, pvMsgData, ui32MsgValue));
            return(NayaData(psDevice, pvMsgData, ui32MsgValue));
        }

        //
        // Ignore SUSPEND and RESUME for now.
        //
        case USB_EVENT_SUSPEND:
        case USB_EVENT_RESUME:
        {
            break;
        }

        //
        // Ignore all other events and return 0.
        //
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

//*****************************************************************************
//
// This is the main application entry function.
//
//*****************************************************************************
int main(void)
{
    volatile uint32_t ui32Loop;
    uint32_t ui32TxCount;
    uint32_t ui32RxCount;
    start_timer_bit = 0;

    config_GPIO();
    config_timer();

    //
    // Enable lazy stacking for interrupt handlers.  This allows floating-point
    // instructions to be used within interrupt handlers, but at the expense of
    // extra stack usage.
    //
    ROM_FPULazyStackingEnable();

    //
    // Set the clocking to run from the PLL at 50MHz
    //
    ROM_SysCtlClockSet(SYSCTL_SYSDIV_4 | SYSCTL_USE_PLL | SYSCTL_OSC_MAIN |
                       SYSCTL_XTAL_16MHZ);

    //
    // Enable the GPIO port that is used for the on-board LED.
    //
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOF);
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOB);
    //
    // Enable the GPIO pins for the LED (PF2 & PF3).
    //
    ROM_GPIOPinTypeGPIOOutput(GPIO_PORTF_BASE, GPIO_PIN_3 | GPIO_PIN_2);
    ROM_GPIOPinTypeGPIOOutput(GPIO_PORTB_BASE, 0xff);
//    ROM_GPIOPinTypeGPIOOutput()

    //
    // Open UART0 and show the application name on the UART.
    //
//    ConfigureUART();

    UARTprintf("\033[2JTiva C Series USB bulk device example\n");
    UARTprintf("---------------------------------\n\n");

    //
    // Not configured initially.
    //What is this????
    g_bUSBConfigured = false;

    //
    // Enable the GPIO peripheral used for USB, and configure the USB
    // pins.
    //
    ROM_SysCtlPeripheralEnable(SYSCTL_PERIPH_GPIOD);
    ROM_GPIOPinTypeUSBAnalog(GPIO_PORTD_BASE, GPIO_PIN_4 | GPIO_PIN_5);

    //
    // Enable the system tick.
    //
    ROM_SysTickPeriodSet(ROM_SysCtlClockGet() / SYSTICKS_PER_SECOND);
    ROM_SysTickIntEnable();
    ROM_SysTickEnable();

    //
    // Tell the user what we are up to.
    //
    //UARTprintf("Configuring USB\n");

    //
    // Initialize the transmit and receive buffers.
    //
    USBBufferInit(&g_sTxBuffer);
    USBBufferInit(&g_sRxBuffer);

    //
    // Set the USB stack mode to Device mode with VBUS monitoring.
    //
    USBStackModeSet(0, eUSBModeForceDevice, 0);

    //
    // Pass our device information to the USB library and place the device
    // on the bus.
    //
    USBDBulkInit(0, &g_sBulkDevice);

    //
    // Wait for initial configuration to complete.
    //
    //UARTprintf("Waiting for host...\n");

    //
    // Clear our local byte counters.
    //
    ui32RxCount = 0;
    ui32TxCount = 0;

//    data_to_tx[tx_front++] = 1;
//    data_to_tx[tx_front++] = 1;
//    data_to_tx[tx_front++] = 1;

    int t_j = 250;
        while(t_j)
        {
//            tx_to_synch_buffer(0x00);
            tx_byte(0x00);
            t_j--;
        }
//        t_j = 24;
        t_j = 1;
        while(t_j)
        {
//            tx_byte(0b11101110)
//            tx_byte(0b10011100);
//            tx_byte(0x00);
            tx_byte('C');
            send_sentence("Hello\n",6);
            send_file();
            send_sentence("END",3);
//            tx_byte('D');
//            tx_byte('E');
//            tx_byte('F');
//            tx_byte('G');
//            tx_byte('H');
//            tx_byte('I');
//            tx_byte('J');
//            tx_byte('K');
//            tx_byte('L');
//            tx_byte('M');
//            tx_byte('N');
//            tx_byte('O');
//            tx_byte('P');
//            tx_byte('Q');
//            tx_byte('R');
//            tx_byte('S');
//            tx_byte('T');
//            tx_byte('U');
//            tx_byte('V');
//            tx_byte('W');
//            tx_byte('X');
//            tx_byte('Y');
//            tx_byte('Z');
//            tx_byte('A');
//            tx_byte('B');
//            tx_byte('d');
//            tx_byte('e');
//            tx_byte('f');
//            tx_byte('g');
//            tx_byte('h');
//            tx_byte('i');
//            tx_byte('j');
//            tx_byte('k');
//            tx_byte('l');
//            tx_byte('m');
//            tx_byte('n');
//            tx_byte('o');
//            tx_byte('p');
//            tx_byte('q');
//            tx_byte('r');
//            tx_byte('s');
//            tx_byte('t');
//            tx_byte('u');
//            tx_byte('v');
//            tx_byte('w');
//            tx_byte('x');
//            tx_byte('y');
//            tx_byte('z');
//            tx_byte('a');
//            tx_byte('b');

//            tx_byte(0xD6);
            t_j--;
        }

    //
    // Main application loop.
    //
//        send_sync_data(3);
//        IntMasterEnable();
//        TimerIntEnable(TIMER0_BASE, TIMER_TIMA_TIMEOUT);
    IntMasterEnable();
    TimerEnable(TIMER0_BASE, TIMER_A); // Start Timer 0A
    while(1)
    {

    }
}
