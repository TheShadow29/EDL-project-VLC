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

//100 -> 38.25k
//75 -> 49.65k
//50 -> 70.71k
//float freq = 50;

bool data_to_tx[2048];
int tx_front = 0;
int tx_back = 0;
int cl_delay = 3233.6/(100 - 6.1629);
int n_bits_tx = 99;
//int test_cl = 100;
bool clk = 0;
void send_data(int);
void tx_byte(uint8_t);
uint8_t byte_test = 0b11001010;

extern int start_send_to_pc;

extern void init_zero();
extern void send_to_pc();

int init_rx()
 {
    SysCtlClockSet(SYSCTL_SYSDIV_4 | SYSCTL_USE_PLL | SYSCTL_XTAL_16MHZ | SYSCTL_OSC_MAIN);
//    config_timer();
    init_zero();
    config_GPIO();
    GPIOPinTypeGPIOOutput(GPIO_PORTF_BASE,GPIO_PIN_2 | GPIO_PIN_3);
//    int count = 0;
//    int data_count = 0;
    int t_i = 100000;
    int t_j = 1;

    uint8_t bro_ka_byte = 0b10101010;
    bool dat_bit = 0;
    t_j = 0;



    IntMasterEnable();

//    while(1)
//    {
//        if(start_send_to_pc == 0)
//        {
//            send_to_pc();
//        }
//    }
}
