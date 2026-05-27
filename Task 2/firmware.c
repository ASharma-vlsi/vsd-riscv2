#include <stdint.h>

#define GPIO_REG (*(volatile uint32_t*)0x0040000C)
#define UART_DATA (*(volatile uint32_t*)0x00400004)
#define UART_STATUS (*(volatile uint32_t*)0x00400008)

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

void print_hex(uint32_t val)
{
    char hex[] = "0123456789ABCDEF";

    for(int i=28; i>=0; i-=4)
    {
        uart_putc(hex[(val >> i) & 0xF]);
    }
}

int main()
{
    uint32_t value;

    GPIO_REG = 0x1F;

    value = GPIO_REG;

    uart_print("GPIO READBACK = 0x");
    print_hex(value);
    uart_print("\n");

    while(1);

    return 0;
}
