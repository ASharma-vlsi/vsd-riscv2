#include <stdint.h>

#define UART_DATA   (*(volatile uint32_t*)0x00400004)
#define UART_STATUS (*(volatile uint32_t*)0x00400008)

void uart_putc(char c)
{
    while(UART_STATUS & (1 << 9));
    UART_DATA = c;
}

void uart_print(char *s)
{
    while(*s)
        uart_putc(*s++);
}

int main()
{
    while(1)
    {
        uart_print("HELLO\r\n");

        for(volatile int i=0; i<200000; i++);
    }
}
