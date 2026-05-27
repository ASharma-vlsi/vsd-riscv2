#include <stdint.h>

#define GPIO_REG    (*(volatile uint32_t*)0x0040000C)
#define UART_DATA   (*(volatile uint32_t*)0x00400004)
#define UART_STATUS (*(volatile uint32_t*)0x00400008)

// Existing print_hex() comes from print.c

void uart_putc(char c)
{
    while(UART_STATUS & (1 << 9));

    UART_DATA = c;
}

void uart_print(char *s)
{
    while(*s)
    {
        uart_putc(*s++);
    }
}

extern void print_hex(unsigned int);

int main()
{
    uint32_t value;

    while(1)
    {
        GPIO_REG = 0x1F;

        value = GPIO_REG;

        uart_print("GPIO READBACK = 0x");

        print_hex(value);

        uart_print("\n");

        for(volatile int i=0; i<1000000; i++);
    }

    return 0;
}
