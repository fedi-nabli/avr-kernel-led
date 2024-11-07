#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

void init_led(void)
{
	DDRB |= (1 << DDB7);
}

int main(void)
{
	init_led();

	while (1)
	{
		PORTB ^= (1 << PORTB7);
		_delay_ms(50);
	}

	return 0;
}
